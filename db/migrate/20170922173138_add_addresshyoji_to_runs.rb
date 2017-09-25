class AddAddresshyojiToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :addresshyoji, :string
  end
end
