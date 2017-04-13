def unauthorized_error
  GraphQL::ExecutionError.new 'Authorized users only.'
end

def authenticated_resource(ctx)
  current_user = ctx[:current_user]
  current_user ? yield(current_user) : unauthorized_error
end

def get_owned_resource(arguments)
  current_user = arguments[:current_user]
  resource_symbol = arguments[:resource_symbol]
  resource_id = arguments[:resource_id]

  pluralized_resource_symbol = resource_symbol.to_s.pluralize.to_sym

  resource = current_user.send(pluralized_resource_symbol)
                         .find_by_id(resource_id)
  resource ? resource : unauthorized_error
end

def authorized_destroy_resource(arguments)
  resource = get_owned_resource(arguments)
  resource.try(:destroy!) || resource
end

def authorized_update_resource(arguments)
  updated_attributes_hash = arguments[:updated_attributes_hash]
  resource = get_owned_resource(arguments)
  resource.try(:update, updated_attributes_hash)
  resource
end
