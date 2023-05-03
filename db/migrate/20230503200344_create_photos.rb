class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.integer :fan_art_id
      t.string :image
      t.integer :owner_id

      t.timestamps
    end
  end
end
