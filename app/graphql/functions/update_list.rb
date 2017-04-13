require_relative '../../helpers/graphql_helpers'

class UpdateList < GraphQL::Function
  attr_reader :type

  argument :id, !GraphQL::ID_TYPE
  argument :listInput, !Types::ListInputType

  def initialize
    @type = Types::ListType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      authorized_update_resource(
        current_user: current_user,
        resource_symbol: :list,
        resource_id: args[:id],
        updated_attributes_hash: args[:listInput].to_h
      )
    end
  end
end
