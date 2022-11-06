class CreateGamesWordsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :games, :words do |t|
      t.index :game_id
      t.index :word_id
    end
  end
end
