class Task < ApplicationRecord
  validates :titre, :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low: 0, middle: 1, high: 2 }
  enum status: { todo: 0, doing: 1, done: 2 }
end
