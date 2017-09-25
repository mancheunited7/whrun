class Createco < ActiveRecord::Migration
  def change
    create_table :comments do |t|


      t.references :user, index: true, foreign_key: true
      t.references :run, index: true, foreign_key: true
      t.text :content
      t.timestamps null: false
    end
  end
end
