class AddFlgzoomToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :flg, :integer
    add_column :runs, :zoom, :integer
  end
end
