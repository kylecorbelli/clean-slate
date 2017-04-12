require_relative '../../helpers/graphql_helpers'

class GetTask < GraphQL::Function
  attr_reader :type

  argument :id, !GraphQL::ID_TYPE

  def initialize
    @type = Types::TaskType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      get_owned_resource(
        current_user: current_user,
        resource_symbol: :task,
        resource_id: args[:id]
      )
    end
  end
end
