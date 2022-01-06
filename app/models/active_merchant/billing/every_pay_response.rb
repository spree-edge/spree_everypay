# frozen_string_literal: true

module ActiveMerchant
  module Billing
    class EveryPayResponse < Response
      def initialize(json_response)
        success = json_response['error'].nil?
        super success,
          success ? 'SUCCESS' : json_response['error']['message'],
          json_response
      end

      def payment_token
        params['token']
      end

      def error
        params['error']
      end
    end
  end
end
