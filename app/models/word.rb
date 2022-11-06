class Word < ApplicationRecord
  has_and_belongs_to_many :games

  validates_presence_of :content
end
