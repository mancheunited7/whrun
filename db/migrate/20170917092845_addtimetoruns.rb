class Addtimetoruns < ActiveRecord::Migration
  def change
    add_column :runs, :time, :integer
  end
end
