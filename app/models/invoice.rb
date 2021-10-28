class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  validates :status, presence: true

  scope :shipped, -> {
    where(status: 'shipped')
  }

  def self.considered_revenue
    joins(:transactions)
      .where(invoices: { status: 'shipped' },
             transactions: { result: 'success' })
  end

  def self.unshipped_order_revenue(quantity = 10)
      joins(:invoice_items)
      .where(status: 'packaged')
      .select('invoices.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS potential_revenue')
      .group(:id)
      .order(potential_revenue: :desc)
      .limit(quantity)
  end
end
