Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :lists, types[Types::ListType] do
    description 'All the lists'
    resolve ->(_, _, _) { List.all }
  end

  field :list, Types::ListType do
    description 'An individual list'
    argument :id, !types.ID
    resolve ->(_, args, _) { List.find(args[:id]) }
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
