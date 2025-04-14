class AddProvinceReferenceToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_reference :addresses, :province, foreign_key: true
    
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE addresses
          SET province_id = (
            SELECT id FROM provinces
            WHERE LOWER(provinces.name) = LOWER(addresses.province)
            LIMIT 1
          )
        SQL
      end
    end
    
    remove_column :addresses, :province, :string
  end
end