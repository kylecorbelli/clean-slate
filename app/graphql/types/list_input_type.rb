Types::ListInputType = GraphQL::InputObjectType.define do
  name 'ListInput'
  argument :title, types.String
end
