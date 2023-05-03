class CreateFanArts < ActiveRecord::Migration[6.0]
  def change
    create_table :fan_arts do |t|
      t.integer :topic
      t.integer :user_id
      t.integer :photos_count

      t.timestamps
    end
  end
end
