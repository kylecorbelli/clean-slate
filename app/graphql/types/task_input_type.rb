Types::TaskInputType = GraphQL::InputObjectType.define do
  name 'TaskInput'
  argument :description, types.String
  argument :isDone, types.Boolean
end
