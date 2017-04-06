require 'clean_slate_spec_helper'

describe 'Task API' do
  include_context 'mocked data'

  it 'should be able to edit existing tasks' do
    task_to_edit = Task.first
    task_to_edit.is_done = false
    task_to_edit.save!
    new_description = 'This is the new task description !@#$%^&*()'
    operation_name = 'EditTask'
    query = %(
      mutation #{operation_name}($id: ID!, $taskInput: TaskInput!) {
        editTask(id: $id, taskInput: $taskInput) {
          id
          description
          isDone
        }
      }
    )
    variables = {
      id: task_to_edit.id,
      taskInput: {
        description: new_description,
        isDone: true
      }
    }
    request_body = {
      operation_name: operation_name,
      query: query,
      variables: variables
    }
    post '/graphql', params: request_body.to_json, headers: headers
    response_body = JSON.parse(response.body)
    task = response_body['data']['editTask']
    expect(task['description']).to eq(new_description)
    expect(task['isDone']).to eq(true)
  end
end
