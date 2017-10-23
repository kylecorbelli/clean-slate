Types::ImageType = GraphQL::ObjectType.define do
  name 'Image'
  field :id, types.ID
  field :url, types.String
  field :task, Types::TaskType
end
