require 'rails_helper'

shared_context 'mocked data' do
  let! :headers do
    {
      'Content-Type' => 'application/json'
    }
  end

  let! :user do
    User.create! do |u|
      u.name = 'Kyle'
      u.email = 'kyle@mail.com'
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
end
