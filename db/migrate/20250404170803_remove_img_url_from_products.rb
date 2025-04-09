class RemoveImgUrlFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :img_url, :string
  end
end
