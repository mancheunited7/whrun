class Createrun < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.date :year
      t.string :prefecture
      t.string :city
      t.integer :kyori
      t.string :taikai
      t.integer :hour
      t.integer :minute
      t.integer :second
      t.string :content
      t.string :avatar
      t.string :image_url
      t.integer :user_id
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
