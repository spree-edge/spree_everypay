# frozen_string_literal: true

module ActiveMerchant
  module Billing
    class EveryPayGateway < Gateway
      self.display_name = 'EveryPay'
      self.money_format = :cents
      self.supported_cardtypes = %i[visa master]

      def initialize(options = {})
        required_options = %i[secret_key gateway_url]

        requires!(options, *required_options)
        @options = options
        super
      end

      def authorize(money, card, params = {})
        params = params.merge(
          secret_key: @options[:secret_key],
          amount: money,
          card: card,
          auto_capture: '0'
        )

        commit(:authorize, params)
      end

      def purchase(money, card, params = {})
        params = params.merge(
          secret_key: @options[:secret_key],
          amount: money,
          card: card,
          auto_capture: '1'
        )

        commit(:purchase, params)
      end

      def capture(money, _response_code, params = {})
        params = params.merge(
          secret_key: @options[:secret_key],
          amount: money,
          token: current_payment(params).everypay_token,
          auto_capture: '1'
        )

        commit(:capture, params)
      end

      def refund(money, _response_code, params = {})
        params = params.merge(
          secret_key: @options[:secret_key],
          amount: money,
          token: refund_order_token(params)
        )

        commit(:refund, params)
      end

      def void(params = {})
        params = params.merge(
          secret_key: @options[:secret_key],
          amount: void_amount(params),
          token: current_payment(params).everypay_token
        )

        commit(:void, params)
      end

      def commit(api_call, params)
        require 'uri'
        require 'net/http'
        raw_response = nil
        response = nil

        scheme = EveryPayApiScheme.for(api_call)
        scheme.validate_params(params)
        req = EveryPayRequest.new(@options, scheme, params)
        url = URI(req.url)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = if capture_event?(scheme)
                    Net::HTTP::Put.new(url)
                  else
                    Net::HTTP::Post.new(url)
                  end

        request['Authorization'] = req.basic_auth
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        request.body = req.body unless capture_event?(scheme)

        response = https.request(request)
        json_response = parse(response, scheme)

        everypay_response = EveryPayResponse.new(json_response)

        if everypay_response.params['token'] && !scheme.name.eql?(:refund) && !(everypay_response.error && scheme.name.eql?(:refund))
          save_token(everypay_response, params)
        end

        everypay_response
      end

      def save_token(everypay_response, params)
        current_payment(params).update(everypay_token: everypay_response.payment_token)
      end

      def current_payment(params)
        ::Spree::Payment.find_by(number: params[:order_id]&.split('-')) #can be added to payment here
      end

      def capture_event?(scheme)
        scheme.name.eql?(:capture)
      end

      def refund_order_token(params)
        ::Spree::Refund.find(params[:originator][:id]).payment.everypay_token
      end

      def void_amount(params)
        amount(current_payment(params).credit_allowed * 100).to_i
      end

      def parse(response, scheme)
        begin
          json_response = JSON.parse(response.body)
          if json_response['error'].nil? && !scheme.successful_response?(json_response)
            json_response['error'] = { 'message' => "Unsuccessful response for :#{scheme.name} API call" }
          end
        rescue JSON::ParserError
          json_response = {
            'error' => {
              'message' => "Non parsable response received from the EveryPay API, status code: #{response.code}, body: #{response.body}"
            }
          }
        end

        json_response
      end
    end
  end
end
