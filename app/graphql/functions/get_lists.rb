require_relative '../../helpers/graphql_helpers'

class GetLists < GraphQL::Function
  attr_reader :type

  def initialize
    @type = Types::ListType.to_list_type
  end

  def call(_, _, ctx)
    authenticated_resource(ctx) { |current_user| current_user.lists.all }
  end
end
