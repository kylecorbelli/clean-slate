# TODO: extract this to a helper file:
def owned_resource(ctx)
  current_user = ctx[:current_user]
  return yield(current_user) if current_user
  GraphQL::ExecutionError.new('Authorized users only.')
end

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :lists, types[Types::ListType] do
    description 'All the lists'
    resolve lambda { |_, _, ctx|
      owned_resource(ctx) { |current_user| current_user.lists.all }
    }
  end

  field :list, Types::ListType do
    description 'An individual list'
    argument :id, !types.ID
    resolve lambda { |_, args, ctx|
      owned_resource(ctx) do |current_user|
        current_user.lists.find(args[:id])
      end
    }
  end

  field :task, Types::TaskType do
    description 'An individual task'
    argument :id, !types.ID
    resolve ->(_, args, _) { Task.find(args[:id]) }
  end

  field :tasks, types[Types::TaskType] do
    description 'All the taks'
    resolve ->(_, _, _) { Task.all }
  end
end
