# frozen_string_literal: true

module Spree
  class Gateway::Everypay < Gateway
    preference :secret_key, :string
    preference :gateway_url, :string

    def method_type
      'everypay'
    end

    def provider_class
      ActiveMerchant::Billing::EveryPayGateway
    end

    def authorize(money, creditcard, gateway_options)
      provider.authorize(money, creditcard, gateway_options)
    end

    def purchase(money, creditcard, gateway_options)
      provider.purchase(money, creditcard, gateway_options)
    end

    def capture(money, _response_code, gateway_options)
      provider.capture(money, gateway_options)
    end

    def credit(money, _response_code, gateway_options)
      provider.refund(money, gateway_options)
    end

    def void(_response_code, gateway_options)
      provider.void(gateway_options)
    end

    def cancel(_response_code, gateway_options)
      provider.void(gateway_options)
    end
  end
end
