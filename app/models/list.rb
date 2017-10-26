class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :images, through: :tasks
end
