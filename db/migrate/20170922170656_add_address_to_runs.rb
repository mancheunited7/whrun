class AddAddressToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :address, :string
    remove_column :runs, :prefecture, :string
    remove_column :runs, :city, :string
  end
end
