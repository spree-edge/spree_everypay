module SpreeEverypay
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_everypay'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_everypay.environment', before: :load_config_initializers do |_app|
      SpreeEverypay::Config = SpreeEverypay::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
    config.after_initialize do
      Rails.configuration.spree.payment_methods << ::Spree::Gateway::Everypay
    end
  end
end
