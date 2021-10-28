class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def self.find_all_by_name(name)
    where('name ILIKE ?', "%#{name}%")
      .order_by_name
  end

  def self.order_by_name(order = 'asc')
    order = 'asc' unless order == 'desc'
    order(name: order)
  end
end
