class AddTimekyoriToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :timehyoji, :string
    add_column :runs, :kyorihyoji, :string
  end
end
