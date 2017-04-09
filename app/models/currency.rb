class Currency < ApplicationRecord
  validates_uniqueness_of :id, :name
end
