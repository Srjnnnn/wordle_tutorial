class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.integer :char_count
      t.string :content

      t.timestamps
    end
  end
end
