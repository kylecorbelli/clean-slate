require 'rails_helper'
require 'simplecov'
require 'codecov'

SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Codecov

shared_context 'mocked data' do
  let! :headers do
    {
      'Content-Type' => 'application/json'
    }
  end

  let! :auth_headers do
    signup_credentials = {
      email: 'kyle@mail.com',
      password: '12345678',
      password_confirmation: '12345678',
      name: 'Kyle'
    }
    post '/auth', params: signup_credentials.to_json, headers: headers
    response_headers = response.headers
    {
      'access-token' => response_headers['access-token'],
      'token-type' => response_headers['token-type'],
      'client' => response_headers['client'],
      'expiry' => response_headers['expiry'],
      'uid' => response_headers['uid'],
      'Content-Type' => response_headers['Content-Type']
    }
  end

  let!(:user) { User.last }

  let! :second_user do
    User.create! do |u|
      u.name = 'Rachael'
      u.email = 'rachael@mail.com'
      u.password = '12345678'
    end
  end

  let! :list_one do
    List.create! do |l|
      l.user = user
      l.title = 'Awesome Specs to Write'
    end
  end

  let! :list_two do
    List.create! do |l|
      l.user = user
      l.title = 'Things to Do this Weekend'
    end
  end

  let! :list_three do
    List.create! do |l|
      l.user = second_user
      l.title = 'Somebody else’s list'
    end
  end

  let! :task_one do
    Task.create! do |t|
      t.list = list_one
      t.description = 'List API specs'
    end
  end

  let! :task_two do
    Task.create! do |t|
      t.list = list_one
      t.description = 'Task API specs'
    end
  end

  let! :task_three do
    Task.create! do |t|
      t.list = list_three
      t.description = 'Somebody else’s task'
    end
  end
end
