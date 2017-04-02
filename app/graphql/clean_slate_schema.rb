CleanSlateSchema = GraphQL::Schema.define do
  query(Types::QueryType)

  # GraphQL::Batch setup:
  lazy_resolve(Promise, :sync)
  instrument(:query, GraphQL::Batch::Setup)
end
