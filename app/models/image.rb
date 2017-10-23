class Image < ApplicationRecord
  belongs_to :task
  delegate :user, to: :task
end
