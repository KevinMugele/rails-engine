class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :result, presence: true

  scope :success, lambda {
    where(result: 'success')
  }
end
