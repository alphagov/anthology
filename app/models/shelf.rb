class Shelf < ApplicationRecord
  has_many :books, dependent: :destroy

  def to_s
    name
  end
end
