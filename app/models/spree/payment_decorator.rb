module Spree
  module PaymentDecorator
    CARD_TYPES = {
      visa: /^4\d{12}(\d{3})?(\d{3})?$/,
      master: /^(5[1-5]\d{4}|677189|222[1-9]\d{2}|22[3-9]\d{3}|2[3-6]\d{4}|27[01]\d{3}|2720\d{2})\d{10}$/,
    }.freeze

    def try_type_from_number(number)
      if number
        numbers = number.delete(' ')
        CARD_TYPES.find { |type, pattern| return type.to_s if numbers =~ pattern }.to_s
      end
    end

    def build_source
      super
      if source_attributes&.has_key?('number')
        cc_type = try_type_from_number(source_attributes['number'])
        source.cc_type = cc_type
      end
    end
  end
end

::Spree::Payment.prepend ::Spree::PaymentDecorator
