CleanSlateSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(Types::MutationType)

  # GraphQL::Batch setup:
  lazy_resolve(Promise, :sync)
  instrument(:query, GraphQL::Batch::Setup)
end
