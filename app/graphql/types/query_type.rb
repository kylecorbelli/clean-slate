Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  
  field :lists, types[Types::ListType] do
    description 'All the lists'
    resolve ->(obj, args, ctx) {
      List.all
    }
  end

  field :list, Types::ListType do
    description 'An individual list'
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      List.find(args[:id])
    }
  end

  field :task, Types::TaskType do
    description 'An individual task'
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Task.find(args[:id])
    }
  end

  field :tasks, types[Types::TaskType] do
    description 'All the taks'
    resolve ->(obj, args, ctx) {
      Task.all
    }
  end
end
