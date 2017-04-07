Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createList, Types::ListType do
    description 'Create a new list'
    argument :title, !types.String
    resolve lambda { |_, args, _|
      List.create! do |list|
        # TODO: this will eventually be the current_user:
        list.user_id = 1
        list.title = args[:title]
      end
    }
  end

  field :createTask, Types::TaskType do
    description 'Create a new task'
    argument :listId, !types.ID
    argument :description, !types.String
    resolve lambda { |_, args, _|
      Task.create! do |task|
        task.description = args[:description]
        task.list = List.find(args[:listId])
      end
    }
  end

  field :editList, Types::ListType do
    description 'Edit an existing list'
    argument :id, !types.ID
    argument :listInput, !Types::ListInputType
    resolve lambda { |_, args, _|
      list = List.find(args[:id])
      list.update! args[:listInput].to_h
      list
    }
  end

  field :editTask, Types::TaskType do
    description 'Edit an existing task'
    argument :id, !types.ID
    argument :taskInput, !Types::TaskInputType
    resolve lambda { |_, args, _|
      task = Task.find(args[:id])
      task.update! args[:taskInput].to_h.deep_underscore_keys
      task
    }
  end

  field :deleteList, Types::ListType do
    description 'Delete an existing list'
    argument :id, !types.ID
    resolve lambda { |_, args, _|
      list = List.find(args[:id])
      list.destroy!
    }
  end

  field :deleteTask, Types::TaskType do
    description 'Delete an existing task'
    argument :id, !types.ID
    resolve lambda { |_, args, _|
      task = Task.find(args[:id])
      task.destroy!
    }
  end
end
