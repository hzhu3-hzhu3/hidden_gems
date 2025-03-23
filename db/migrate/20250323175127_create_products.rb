class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :img_url

      t.timestamps
    end
  end
end
