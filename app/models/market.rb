class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end

  def self.search_state(params)
    where("state ILIKE ?", "%#{params[:state]}%")
  end

  def self.search_name(params)
    where("name ILIKE ?", "%#{params[:name]}%")
  end
end