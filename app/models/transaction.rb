class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :result, presence: true

  scope :success, -> {
    where(result: 'success')
  }
end
