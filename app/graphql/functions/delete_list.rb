require_relative '../../helpers/graphql_helpers'

class DeleteList < GraphQL::Function
  attr_reader :type

  argument :id, !GraphQL::ID_TYPE

  def initialize
    @type = Types::ListType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      authorized_destroy_resource(
        current_user: current_user,
        resource_symbol: :list,
        resource_id: args[:id]
      )
    end
  end
end
