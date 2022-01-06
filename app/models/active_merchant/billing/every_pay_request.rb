# frozen_string_literal: true

module ActiveMerchant
  module Billing
    class EveryPayRequest
      attr_accessor :gateway_options, :scheme, :params

      def initialize(gateway_options, scheme, params)
        self.gateway_options = gateway_options
        self.scheme = scheme
        self.params = params
      end

      def data
        build_data.to_json if scheme.post_request?
      end

      def url
        uri = URI(gateway_options.fetch(:gateway_url))
        uri.path += scheme.request_path(params[:token]).gsub(/(:\w*)/) do |m|
          m.gsub(m, params.fetch(m.tr(':', '').to_sym))
        end
        uri.to_s
      end

      def body
        URI.encode_www_form(build_data)
      end

      def build_data
        payload = {}
        if params[:auto_capture].present?
          payload = {
            'card_number' => params[:card][:card_number],
            'expiration_year' => params[:card][:year],
            'expiration_month' => params[:card][:month],
            'holder_name' => params[:card][:name],
            'cvv' => params[:card][:cvv],
            'amount' => params[:amount],  # need to charge the card
            'description' => params[:order_id],
            'capture' => params[:auto_capture]
          }
        elsif %i[refund void].include?(scheme.name)
          payload = {
            'payment' => params[:token],
            'amount' => params[:amount],
            'description' => params[:order_id]
          }
        end

        payload
      end

      def method
        scheme.request_method
      end

      def headers
        {
          'Content-type' => 'application/x-www-form-urlencoded',
          'Accept' => 'application/json',
          'Authorization' => basic_auth
        }
      end

      def basic_auth
        "Basic #{Base64.strict_encode64(gateway_options.fetch(:secret_key))}"
      end
    end
  end
end
