class Image < ApplicationRecord
  belongs_to :task
  delegate :user, to: :task
  delegate :list, to: :task
end
