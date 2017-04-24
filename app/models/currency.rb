class Currency < ApplicationRecord
  validates_uniqueness_of :id, :name

  def self.convert_to_hash
    curr_array = {}
    all.each { |currency| curr_array.merge!(currency.name.to_s => currency.id) }
    curr_array
  end
end
