class RemoveFlgFromRuns < ActiveRecord::Migration
  def down
    remove_columns :runs, :flg, :integer
    remove_columns :runs, :zoom, :integer
  end
end
