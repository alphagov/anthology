class Shelf < ApplicationRecord
  has_many :books

  def to_s
    name
  end
end
