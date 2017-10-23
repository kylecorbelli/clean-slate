require_relative '../../helpers/graphql_helpers'

class CreateImage < GraphQL::Function
  attr_reader :type

  argument :taskId, !GraphQL::ID_TYPE
  argument :url, !GraphQL::STRING_TYPE

  def initialize
    @type = Types::ImageType
  end

  def call(_, args, ctx)
    authenticated_resource(ctx) do |current_user|
      task = current_user.tasks.find_by_id(args[:taskId])
      return unauthorized_error if task.nil?
      task.images.create! do |image|
        image.url = args[:url]
      end
    end
  end
end
