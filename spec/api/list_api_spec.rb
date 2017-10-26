require 'clean_slate_spec_helper'

describe 'List API' do
  include_context 'mocked data'

  let :lists_request_body do
    query = %(
      query {
        lists {
          title
        }
      }
    )
    {
      query: query,
      variables: nil
    }
  end

  let :list_request_body do
    query = %(
      query List($id: ID!){
        list(id: $id) {
          title
        }
      }
    )
    {
      query: query,
      variables: {
        id: list_one.id
      }
    }
  end

  let :create_list_request_body do
    query = %(
      mutation CreateList($title: String!) {
        createList(title: $title) {
          title
        }
      }
    )
    {
      query: query,
      variables: {
        title: 'Some cool new list of things to do'
      }
    }
  end

  let :update_list_request_body do
    query = %(
      mutation UpdateList($id: ID!, $listInput: ListInput!) {
        updateList(id: $id, listInput: $listInput) {
          title
        }
      }
    )
    {
      query: query,
      variables: {
        id: list_one.id,
        listInput: {
          title: 'This should be a totally new title'
        }
      }
    }
  end

  let :delete_list_request_body do
    query = %(
      mutation DeleteList($id: ID!) {
        deleteList(id: $id) {
          title
        }
      }
    )
    {
      query: query,
      variables: {
        id: list_one.id
      }
    }
  end

  let :delete_all_tasks_from_list_request_body do
    query = %(
      mutation DeleteAllTasksFromList($list_id: ID!) {
        deleteAllTasksFromList(listId: $list_id) {
          id
        }
      }
    )
    {
      query: query,
      variables: {
        list_id: list_one.id
      }
    }
  end

  context 'when a user is not logged in' do
    it 'should not allowing querying of lists' do
      send_unauthorized_request(lists_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow querying of a single list' do
      send_unauthorized_request(list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow the creation of a list' do
      send_unauthorized_request(create_list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow the updating of a list' do
      send_unauthorized_request(update_list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow the deleting of a list' do
      send_unauthorized_request(delete_list_request_body)
      expect_unauthorized_error(response)
    end
  end

  context 'when a user is logged in' do
    it 'should be able to query all lists for the current user' do
      send_authorized_request(lists_request_body)
      response_body = parse_json(response)
      lists = response_body['data']['lists']
      expect(lists).to have(2).lists
      list_title = lists[0]['title']
      expect(list_title).to eq(list_one.title)
    end

    it 'should not be able to query another user’s list' do
      cloned_list_request_body = list_request_body.clone
      cloned_list_request_body[:variables][:id] = list_three.id
      send_authorized_request(cloned_list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should be able to query a single list belonging to the current user' do
      send_authorized_request(list_request_body)
      response_body = parse_json(response)
      list = response_body['data']['list']
      expect(list['title']).to eq(list_one.title)
    end

    it 'should be able to create a new list for the current user' do
      send_authorized_request(create_list_request_body)
      response_body = parse_json(response)
      new_list_title = response_body['data']['createList']['title']
      expected_new_list_title = create_list_request_body[:variables][:title]
      expect(new_list_title).to eq(expected_new_list_title)
      list = List.last
      expect(list.title).to eq(expected_new_list_title)
      expect(list.user).to eq(user)
    end

    it 'should not be able to update another user’s list' do
      cloned_update_list_request_body = update_list_request_body.clone
      cloned_update_list_request_body[:variables][:id] = list_three.id
      send_authorized_request(cloned_update_list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should be able to update an existing list belonging to the current'\
       ' user' do
      send_authorized_request(update_list_request_body)
      response_body = parse_json(response)
      updated_list_title = response_body['data']['updateList']['title']
      variables = update_list_request_body[:variables]
      expected_updated_list_title = variables[:listInput][:title]
      expect(updated_list_title).to eq(expected_updated_list_title)
      list_one.reload
      expect(list_one.title).to eq(expected_updated_list_title)
    end

    it 'should not be able to delete another user’s list' do
      cloned_delete_list_request_body = delete_list_request_body.clone
      cloned_delete_list_request_body[:variables][:id] = list_three.id
      send_authorized_request(cloned_delete_list_request_body)
      expect_unauthorized_error(response)
    end

    it 'should be able to delete an existing list belonging to the current'\
       ' user' do
      send_authorized_request(delete_list_request_body)
      response_body = parse_json(response)
      deleted_list_title = response_body['data']['deleteList']['title']
      expect(deleted_list_title).to eq(list_one.title)
      deleted_list = user.lists.find_by_id(list_one.id)
      expect(deleted_list).to be_nil
    end

    it 'deletes all tasks on a particular list' do
      send_authorized_request(delete_all_tasks_from_list_request_body)
      response_body = parse_json(response)
      list = List.find_by_id(list_one.id)
      expect(list.tasks.count).to eq(0)
      expect(list.images.count).to eq(0)
    end
  end
end
