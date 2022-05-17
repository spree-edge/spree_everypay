# frozen_string_literal: true
module SpreeEverypay
  module Spree
    module PaymentDecorator
      CARD_TYPES = {
        visa: /^4\d{12}(\d{3})?(\d{3})?$/,
        master: /^(5[1-5]\d{4}|677189|222[1-9]\d{2}|22[3-9]\d{3}|2[3-6]\d{4}|27[01]\d{3}|2720\d{2})\d{10}$/
      }.freeze

      def try_type_from_number(number)
        return unless number

        numbers = number.delete(' ')
        CARD_TYPES.find { |type, pattern| return type.to_s if numbers =~ pattern }.to_s
      end

      # applying credit card type from regex in spree_credit_card model will move to token eventually
      def build_source
        super
        if source_attributes&.key?('number')
          cc_type = try_type_from_number(source_attributes['number'])
          source.cc_type = cc_type
        end
      end
    end
  end
end

::Spree::Payment.prepend ::SpreeEverypay::Spree::PaymentDecorator
