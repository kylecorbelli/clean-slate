require_relative '../../helpers/graphql_helpers'

class GetImages < GraphQL::Function
  attr_reader :type

  def initialize
    @type = Types::ImageType.to_list_type
  end

  def call(_, _, ctx)
    authenticated_resource(ctx) { |current_user| current_user.images.all }
  end
end
