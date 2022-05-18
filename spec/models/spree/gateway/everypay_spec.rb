require 'spec_helper'

describe Spree::Gateway::Everypay do
  let (:gateway) { described_class.create!(name: 'Everypay', stores: [::Spree::Store.default]) }

  context '.provider_class' do
    it 'is a Everypay gateway' do
      expect(gateway.provider_class).to eq ::ActiveMerchant::Billing::EveryPayGateway
    end
  end

  describe 'options' do
    it 'include :test => true when server is "test"' do
      gateway.preferred_server = "test"
      expect(gateway.options[:test]).to be true
    end

    it 'does not include :test when server is "live"' do
      gateway.preferred_server = "live"
      expect(gateway.options[:test]).to be false
    end
  end
end
