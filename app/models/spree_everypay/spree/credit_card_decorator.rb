module SpreeEverypay
  module Spree
    module CreditCardDecorator
      def self.prepended(base)
        base.attr_accessor :card_number, :cvv
        base.before_save :set_card_number_and_cvv
      end

      def set_card_number_and_cvv
        self.card_number ||= number
        self.cvv ||= verification_value
      end
    end
  end
end

::Spree::CreditCard.prepend SpreeEverypay::Spree::CreditCardDecorator if ::Spree::CreditCard.included_modules.exclude?(SpreeEverypay::Spree::CreditCardDecorator)
