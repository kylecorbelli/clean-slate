class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :lists, dependent: :destroy
  has_many :tasks, through: :lists
  has_many :images, through: :tasks
end
