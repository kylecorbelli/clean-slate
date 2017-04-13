require_relative '../../helpers/graphql_helpers'
project_root = File.expand_path(Dir.pwd)
Dir.glob(project_root + '/app/graphql/functions/*').each { |file| require file }

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createList, function: CreateList.new
  field :createTask, function: CreateTask.new
  field :updateList, function: UpdateList.new
  field :updateTask, function: UpdateTask.new
  field :deleteList, function: DeleteList.new
  field :deleteTask, function: DeleteTask.new
end
