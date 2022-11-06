class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :attempts
      t.boolean :won

      t.timestamps
    end
  end
end
