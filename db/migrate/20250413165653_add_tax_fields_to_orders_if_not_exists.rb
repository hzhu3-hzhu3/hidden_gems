class AddTaxFieldsToOrdersIfNotExists < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:orders, :gst_rate)
      add_column :orders, :gst_rate, :decimal, precision: 5, scale: 2, default: 0.05
    end
    
    unless column_exists?(:orders, :pst_rate)
      add_column :orders, :pst_rate, :decimal, precision: 5, scale: 2, default: 0.07
    end
    
    unless column_exists?(:order_items, :gst_amount)
      add_column :order_items, :gst_amount, :decimal, precision: 10, scale: 2, default: 0
    end
    
    unless column_exists?(:order_items, :pst_amount)
      add_column :order_items, :pst_amount, :decimal, precision: 10, scale: 2, default: 0
    end
  end
end