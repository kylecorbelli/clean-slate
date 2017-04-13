require_relative '../../helpers/graphql_helpers'
project_root = File.expand_path(Dir.pwd)
Dir.glob(project_root + '/app/graphql/functions/*').each { |file| require file }

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :lists, function: GetLists.new
  field :list, function: GetList.new
  field :tasks, function: GetTasks.new
  field :task, function: GetTask.new
end
