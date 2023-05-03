class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :role
      t.string :content
      t.integer :fan_art_id
      t.integer :user_id

      t.timestamps
    end
  end
end
