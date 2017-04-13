require 'clean_slate_spec_helper'

describe 'Task API' do
  include_context 'mocked data'

  let :tasks_request_body do
    query = %(
      query {
        tasks {
          description
        }
      }
    )
    {
      query: query,
      variables: nil
    }
  end

  let :tasks_from_a_list_request_body do
    query = %(
      query TasksFromList($listId: ID!) {
        list(id: $listId) {
          tasks {
            description
          }
        }
      }
    )
    {
      query: query,
      variables: {
        listId: list_two.id
      }
    }
  end

  let :task_request_body do
    query = %(
      query Task($id: ID!) {
        task(id: $id) {
          description
        }
      }
    )
    {
      query: query,
      variables: {
        id: task_one.id
      }
    }
  end

  let :create_task_request_body do
    query = %(
      mutation CreateTask($listId: ID!, $description: String!) {
        createTask(listId: $listId, description: $description) {
          description
          isDone
        }
      }
    )
    {
      query: query,
      variables: {
        listId: list_two.id,
        description: 'This is a neat new task'
      }
    }
  end

  let :update_task_request_body do
    query = %(
      mutation UpdateTask($id: ID!, $taskInput: TaskInput!) {
        updateTask(id: $id, taskInput: $taskInput) {
          description
          isDone
        }
      }
    )
    {
      query: query,
      variables: {
        id: task_one.id,
        taskInput: {
          description: 'This ought to be a new description',
          isDone: true
        }
      }
    }
  end

  let :delete_task_request_body do
    query = %(
      mutation DeleteTask($id: ID!) {
        deleteTask(id: $id) {
          description
        }
      }
    )
    {
      query: query,
      variables: {
        id: task_one.id
      }
    }
  end

  context 'when a user is not logged in' do
    it 'should not allow querying of tasks' do
      send_unauthorized_request(tasks_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow querying of a single task' do
      send_unauthorized_request(task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow creation of a task' do
      send_unauthorized_request(create_task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow updating of a task' do
      send_unauthorized_request(update_task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should not allow deletion of tasks' do
      send_unauthorized_request(delete_task_request_body)
      expect_unauthorized_error(response)
    end
  end

  context 'when a user is logged in' do
    it 'should be able to query all tasks for the current user' do
      send_authorized_request(tasks_request_body)
      response_body = parse_json(response)
      tasks = response_body['data']['tasks']
      expect(tasks).to have(3).tasks
      task_description = tasks[0]['description']
      expect(task_description).to eq(task_one.description)
    end

    it 'should be able to query all the tasks from a given list' do
      send_authorized_request(tasks_from_a_list_request_body)
      response_body = parse_json(response)
      tasks = response_body['data']['list']['tasks']
      expect(tasks).to have(1).task
    end

    it 'should not be able to query another user’s task' do
      cloned_task_request_body = task_request_body.clone
      cloned_task_request_body[:variables][:id] = task_three.id
      send_authorized_request(cloned_task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should be able to query a single task belonging to the current user' do
      send_authorized_request(task_request_body)
      response_body = parse_json(response)
      task = response_body['data']['task']
      expect(task['description']).to eq(task_one.description)
    end

    it 'should not allow creation of tasks on another user’s list' do
      cloned_create_task_request_body = create_task_request_body.clone
      cloned_create_task_request_body[:variables][:listId] = list_three.id
      send_authorized_request(cloned_create_task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should allow creation of a task for the current user for a'\
       ' given list' do
      send_authorized_request(create_task_request_body)
      response_body = parse_json(response)
      created_task = response_body['data']['createTask']
      expected_description = create_task_request_body[:variables][:description]
      expect(created_task['description']).to eq(expected_description)
      expect(created_task['isDone']).to eq(false)
      expect(Task.last.description).to eq(expected_description)
    end

    it 'should allow editing of a task belonging to the current user' do
      send_authorized_request(update_task_request_body)
      response_body = parse_json(response)
      task_input = update_task_request_body[:variables][:taskInput]
      task_from_response = response_body['data']['updateTask']
      expect(task_from_response['description']).to eq(task_input[:description])
      expect(task_from_response['isDone']).to eq(task_input[:isDone])
      task = Task.find(update_task_request_body[:variables][:id])
      expect(task.description).to eq(task_input[:description])
      expect(task.is_done).to eq(task_input[:isDone])
    end

    it 'should not allow editing of another user’s tasks' do
      cloned_update_task_request_body = update_task_request_body.clone
      cloned_update_task_request_body[:variables][:id] = task_three.id
      send_authorized_request(cloned_update_task_request_body)
      expect_unauthorized_error(response)
    end

    it 'should allow deleting a task belonging to the current user' do
      send_authorized_request(delete_task_request_body)
      response_body = parse_json(response)
      task_from_response = response_body['data']['deleteTask']
      expect(task_from_response['description']).to eq(task_one.description)
      deleted_task = Task.find_by_id(task_one.id)
      expect(deleted_task).to be_nil
    end

    it 'should not allow deleting another user’s task' do
      cloned_delete_task_request_body = delete_task_request_body.clone
      cloned_delete_task_request_body[:variables][:id] = task_three.id
      send_authorized_request(cloned_delete_task_request_body)
      expect_unauthorized_error(response)
    end
  end
end
