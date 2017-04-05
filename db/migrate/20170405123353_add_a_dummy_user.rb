class AddADummyUser < ActiveRecord::Migration[5.0]
  USER_INFO = {
    name: 'Princess Rachael',
    email: 'princess@mail.com',
    password: '12345678'
  }

  def up
    User.create! USER_INFO
  end

  def down
    user = User.find_by_email(USER_INFO[:email])
    user.destroy!
  end
end
