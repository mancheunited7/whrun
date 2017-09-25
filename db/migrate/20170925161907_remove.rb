class Remove < ActiveRecord::Migration
  def change
    remove_column :runs, :flg
    remove_column :runs, :zoom
  end
end
