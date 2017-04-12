require_relative '../../helpers/graphql_helpers'

class CreateTask < GraphQL::Function
  attr_reader :type

  argument :listId, !GraphQL::ID_TYPE
  argument :description, !GraphQL::STRING_TYPE

  def initialize
    @type = Types::TaskType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      list = current_user.lists.find_by_id(args[:listId])
      return unauthorized_error if list.nil?
      list.tasks.create! do |task|
        task.description = args[:description]
      end
    end
  end
end
