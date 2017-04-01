class Task < ApplicationRecord
  belongs_to :list
  delegate :user, to: :list
end
