# frozen_string_literal: true

class Shelf < ActiveRecord::Base
  has_many :books

  def to_s
    name
  end
end
