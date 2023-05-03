class CreateFanArts < ActiveRecord::Migration[6.0]
  def change
    create_table :fan_arts do |t|
      t.string :topic
      t.integer :user_id

      t.timestamps
    end
  end
end
