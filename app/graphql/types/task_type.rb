Types::TaskType = GraphQL::ObjectType.define do
  name 'Task'
  field :id, types.ID
  field :description, types.String
  field :name, types.String
  field :isDone, types.Boolean, property: :is_done
  field :list, Types::ListType
  field :image, Types::ImageType
end
