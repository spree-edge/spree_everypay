# frozen_string_literal: true

module ActiveMerchant
  module Billing
    class EveryPayApiScheme
      REQUIRED_PARAM = :required

      POST_REQUEST = :post
      GET_REQUEST = :get
      PUT_REQUEST = :put

      PAYMENT_STATES = [
        PAYMENT_STATE_SETTLED = 'Captured',
        PAYMENT_STATE_AUTHORIZED = 'Pre Authorized'
      ].freeze

      SCHEME = {
        authorize: {
          request: {
            method: POST_REQUEST,
            path: '/payments',
            params: {
              secret_key: REQUIRED_PARAM
            }
          },
          response: {
            successful_states: [PAYMENT_STATE_AUTHORIZED]
          }
        },
        capture: {
          request: {
            method: PUT_REQUEST,
            path: '/payments',
            params: {
              secret_key: REQUIRED_PARAM
            }
          },
          response: {
            successful_states: [PAYMENT_STATE_SETTLED]
          }
        },
        purchase: {
          request: {
            method: POST_REQUEST,
            path: '/payments',
            params: {
              secret_key: REQUIRED_PARAM
            }
          },
          response: {
            successful_states: [PAYMENT_STATE_SETTLED]
          }
        },
        refund: {
          request: {
            method: POST_REQUEST,
            path: '/refunds',
            params: {
              secret_key: REQUIRED_PARAM
            }
          },
          response: {
            successful_states: [PAYMENT_STATE_SETTLED]
          }
        },
        void: {
          request: {
            method: POST_REQUEST,
            path: '/refunds',
            params: {
              secret_key: REQUIRED_PARAM
            }
          },
          response: {
            successful_states: [PAYMENT_STATE_SETTLED]
          }
        }
      }.freeze

      def self.for(api_call)
        new(api_call)
      end

      def initialize(api_call)
        @api_call = api_call
        @scheme = SCHEME.fetch(api_call)
      end

      def successful_response?(json_response)
        successful_response_states = @scheme.fetch(:response, {}).fetch(:successful_states, [])
        successful_response_states.empty? || successful_response_states.include?(json_response['status'])
      end

      def validate_params(params)
        mandatory_params = request_params.map { |key, type| key if type == REQUIRED_PARAM }.compact
        all_params = request_params.keys

        missing_params = mandatory_params - params.keys
        raise ArgumentError, "Missing request params: #{missing_params}" if missing_params.any?
      end

      def name
        @api_call
      end

      def request_params
        @scheme.fetch(:request).fetch(:params, {})
      end

      def request_method
        @scheme.fetch(:request).fetch(:method)
      end

      def post_request?
        request_method == POST_REQUEST
      end

      def get_request?
        request_method == GET_REQUEST
      end

      def request_path(token)
        path = @scheme.fetch(:request).fetch(:path)
        path = "/payments/#{token}/capture" if @api_call.eql?(:capture) && token
        path
      end
    end
  end
end
