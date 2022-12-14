class Game < ApplicationRecord
  has_and_belongs_to_many :words

  def check_win?
    self.known_indexes.length == self.words.first.content.length
  end

  def win
    self.won = true
    self.known_indexes = [0, 1, 2, 3, 4]
    save
  end
end
