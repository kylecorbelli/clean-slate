require 'clean_slate_spec_helper'

describe 'List API' do
  include_context 'mocked data'

  it 'should be able to query all lists for the current user' do
    query_string = %(
      query {
        lists {
          title
        }
      }
    )
    request_body = {
      query: query_string,
      variables: nil
    }
    post '/graphql', params: request_body.to_json, headers: auth_headers
    response_body = JSON.parse(response.body)
    lists = response_body['data']['lists']

    expect(lists).to have(2).lists

    list_title = lists[0]['title']
    expect(list_title).to eq(list_one.title)
  end
end
