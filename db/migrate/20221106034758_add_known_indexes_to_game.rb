class AddKnownIndexesToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :known_indexes, :integer, array: true, default: []
  end
end
