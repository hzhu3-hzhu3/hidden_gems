class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :slug
      t.text :body

      t.timestamps
    end
  end
end
