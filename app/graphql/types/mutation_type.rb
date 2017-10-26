require_relative '../../helpers/graphql_helpers'
project_root = File.expand_path(Dir.pwd)
Dir.glob(project_root + '/app/graphql/functions/*').each { |file| require file }

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createImage, function: CreateImage.new
  field :createList, function: CreateList.new
  field :createTask, function: CreateTask.new
  field :updateList, function: UpdateList.new
  field :updateTask, function: UpdateTask.new
  field :deleteImage, function: DeleteImage.new
  field :deleteList, function: DeleteList.new
  field :deleteTask, function: DeleteTask.new
  field :deleteAllTasksFromList, function: DeleteAllTasksFromList.new
end
