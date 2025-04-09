class AddTaxFieldsToOrdersAndItems < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 2, default: 0.05
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 2, default: 0.07
    add_column :order_items, :gst_amount, :decimal, precision: 10, scale: 2, default: 0
    add_column :order_items, :pst_amount, :decimal, precision: 10, scale: 2, default: 0
  end
end
