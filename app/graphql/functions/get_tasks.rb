require_relative '../../helpers/graphql_helpers'

class GetTasks < GraphQL::Function
  attr_reader :type

  def initialize
    @type = Types::TaskType.to_list_type
  end

  def call(_, _, ctx)
    authenticated_resource(ctx) { |current_user| current_user.tasks.all }
  end
end
