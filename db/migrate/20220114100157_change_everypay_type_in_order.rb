class ChangeEverypayTypeInOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :spree_orders, :everypay_token, :string
    add_column :spree_payments, :everypay_token, :string
  end
end
