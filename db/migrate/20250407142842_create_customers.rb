class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
