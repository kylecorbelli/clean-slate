require_relative '../../helpers/graphql_helpers'

class DeleteAllTasksFromList < GraphQL::Function
  attr_reader :type

  argument :listId, !GraphQL::ID_TYPE

  def initialize
    @type = Types::ListType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      list = current_user.lists.find_by_id(args[:listId])
      list.tasks.destroy_all
      list
    end
  end
end
