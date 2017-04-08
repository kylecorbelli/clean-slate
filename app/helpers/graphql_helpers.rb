def owned_resource(ctx)
  current_user = ctx[:current_user]
  return yield(current_user) if current_user
  GraphQL::ExecutionError.new 'Authorized users only.'
end

def exclusive_resource(arguments)
  current_user = arguments[:current_user]
  resource_symbol = arguments[:resource_symbol]
  resource_id = arguments[:resource_id]
  action_symbol = arguments[:action_symbol]
  input_object = arguments[:input_object]

  resource = current_user.send(resource_symbol).find_by_id(resource_id)
  if (input_object && resource.try(action_symbol, input_object)) ||
     resource.try(action_symbol)
    resource
  else
    GraphQL::ExecutionError.new 'Authorized users only.'
  end
end
