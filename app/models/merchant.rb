class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.find_all_by_name(name)
    where('name ILIKE ?', "%#{name}%")
      .order_by_name
  end

  def self.find_by_name(name)
    order_by_name
      .find_by('name ILIKE ?', "%#{name}%")
  end

  def self.order_by_name(order = 'asc')
    order = 'asc' unless order == 'desc'
    order(name: order)
  end

  def self.top_merchants_by_revenue(quantity = 5)
    joins(invoices: :invoice_items)
      .merge(Invoice.considered_revenue)
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .group(:id)
      .order(total_revenue: :desc)
      .limit(quantity)
  end

  def revenue
    invoices
      .considered_revenue
      .joins(:transactions)
      .joins(:invoice_items)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.most_items_sold(quantity = 5)
    joins(invoices: :invoice_items)
      .merge(Invoice.considered_revenue)
      .select('merchants.*, SUM(invoice_items.quantity) AS item_count')
      .group(:id)
      .order(item_count: :desc)
      .limit(quantity)
  end
end
