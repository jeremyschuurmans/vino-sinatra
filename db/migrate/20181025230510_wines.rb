class Wines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :name
      t.string :winery
      t.string :vintage
      t.string :origin
      t.float :price
      t.integer :rating
      t.text :tasting_notes
      t.text :other_notes
      t.integer :user_id
    end
  end
end
