class Blog < ApplicationRecord
  validates :title, :content, presence: true
  validates :title, :content, length: { maximum: 140 }
end
