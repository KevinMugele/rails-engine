class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  validates :name, presence: true

  def self.find_all_by_name(name = nil)
    return nil if name.nil?

    where('name ILIKE ?', "%#{name}%")
      .order_by_name
  end

  def self.find_by_name(name = nil)
    return nil if name.nil?

    order_by_name
      .find_by('name ILIKE ?', "%#{name}%")
  end

  def self.order_by_name(order = 'asc')
    order = 'asc' unless order == 'desc'
    order(name: order)
  end
end
