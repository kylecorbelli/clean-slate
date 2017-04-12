require_relative '../../helpers/graphql_helpers'

class CreateList < GraphQL::Function
  attr_reader :type

  argument :title, GraphQL::STRING_TYPE

  def initialize
    @type = Types::ListType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      List.create! do |list|
        list.user = current_user
        list.title = args[:title]
      end
    end
  end
end
