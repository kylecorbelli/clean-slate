class Task < ApplicationRecord
  belongs_to :list
  has_many :images, dependent: :destroy
  delegate :user, to: :list
end
