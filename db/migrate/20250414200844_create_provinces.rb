class CreateProvinces < ActiveRecord::Migration[8.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.decimal :gst_rate, precision: 5, scale: 2, default: 0.05
      t.decimal :pst_rate, precision: 5, scale: 2, default: 0.0
      t.boolean :has_hst, default: false

      t.timestamps
    end
    
    add_index :provinces, :name, unique: true
  end
end