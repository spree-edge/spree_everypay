class AddEverypayTokenToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :everypay_token, :string
  end
end
