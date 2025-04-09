class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:orders)
      create_table :orders do |t|
        t.references :customer, null: false, foreign_key: true
        t.references :address, null: false, foreign_key: true
        t.integer :status, default: 0
        t.decimal :total_price, precision: 10, scale: 2

        t.timestamps
      end
    end
  end
end