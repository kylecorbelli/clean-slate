require_relative '../../helpers/graphql_helpers'

class UpdateTask < GraphQL::Function
  attr_reader :type

  argument :id, !GraphQL::ID_TYPE
  argument :taskInput, !Types::TaskInputType

  def initialize
    @type = Types::TaskType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      authorized_update_resource(
        current_user: current_user,
        resource_symbol: :task,
        resource_id: args[:id],
        updated_attributes_hash: args[:taskInput].to_h.deep_underscore_keys
      )
    end
  end
end
