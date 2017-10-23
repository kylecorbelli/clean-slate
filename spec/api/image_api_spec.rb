require 'clean_slate_spec_helper'

describe 'Image API' do
  include_context 'mocked data'

  let :images_request_body do
    query = %(
      query {
        images {
          url
        }
      }
    )
    {
      query: query,
      variables: nil
    }
  end

  let :single_image_request_body do
    query = %(
      query Image($id: ID!) {
        image(id: $id) {
          url
        }
      }
    )
    {
      query: query,
      variables: {
        id: image_one.id
      }
    }
  end

  let :create_image_request_body do
    query = %(
      mutation CreateImage($taskId: ID!, $url: String!) {
        createImage(taskId: $taskId, url: $url) {
          url
        }
      }
    )
    {
      query: query,
      variables: {
        taskId: task_two.id,
        url: 'http://www.newurl.com'
      }
    }
  end

  let :delete_image_request_body do
    query = %(
      mutation DeleteImage($id: ID!) {
        deleteImage(id: $id) {
          url
        }
      }
    )
    {
      query: query,
      variables: {
        id: image_two.id
      }
    }
  end

  context 'when a user is not logged in' do
  end

  context 'when a user is logged in' do
    it 'queries all images for the current user' do
      send_authorized_request(images_request_body)
      response_body = parse_json(response)
      images = response_body['data']['images']
      expect(images).to have(2).images
      first_image_url = images[0]['url']
      expect(first_image_url).to eq(image_one.url)
    end

    it 'queries a single image' do
      send_authorized_request(single_image_request_body)
      response_body = parse_json(response)
      image = response_body['data']['image']
      expect(image['url']).to eq(image_one.url)
    end

    it 'creates a new image' do
      send_authorized_request(create_image_request_body)
      response_body = parse_json(response)
      image = response_body['data']['createImage']
      expected_url = create_image_request_body[:variables][:url]
      expect(image['url']).to eq(expected_url)
    end

    it 'deletes an image' do
      send_authorized_request(delete_image_request_body)
      response_body = parse_json(response)
      image = response_body['data']['deleteImage']      
      expected_url = image_two.url
      expect(image['url']).to eq(expected_url)
      deleted_image = Image.find_by_id(image_two.id)
      expect(deleted_image).to be_nil
    end
  end
end
