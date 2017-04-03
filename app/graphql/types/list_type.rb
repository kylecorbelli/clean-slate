Types::ListType = GraphQL::ObjectType.define do
  name 'List'
  field :id, types.ID
  field :title, types.String
  field :tasks, types[Types::TaskType]
end
