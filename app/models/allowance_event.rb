class AllowanceEvent < ApplicationRecord
  validates :event_type, presence: true
  validates :amount, presence: true, numericality: true
  validates :timestamp, presence: true
end
