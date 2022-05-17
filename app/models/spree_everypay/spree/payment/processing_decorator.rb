# frozen_string_literal: true

module SpreeEverypay
  module Spree
    module Payment
      module ProcessingDecorator
        def cancel!
          if payment_method.type.eql?('Spree::Gateway::Everypay')
            response = payment_method.cancel(response_code, gateway_options)
            handle_response(response, :void, :failure)
          else
            super
          end
        end
      end
    end
  end
end

::Spree::Payment::Processing.prepend ::SpreeEverypay::Spree::Payment::ProcessingDecorator
