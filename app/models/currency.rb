# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Currency < ApplicationRecord
  validates_uniqueness_of :id, :name
  validates_presence_of :id, :name

  has_many :historical_currency_rates

  class << self
    def convert_to_hash
      curr_arr = {}
      all.each { |currency| curr_arr.merge!(currency.name.to_s => currency.id) }
      curr_arr
    end
  end
end
