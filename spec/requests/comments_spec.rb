require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  # initialize test data
  let!(:a_user) { create(:user, token: "token#1") }
  let!(:comments) { create_list(:comment, 10, user: a_user) }
  let(:comment_id) { comments.first.id }

  # Test suite for GET /comments
  describe 'GET /comments.json' do
    # make HTTP get request before each example
    before do
      get '/comments.json'
    end

    it 'returns comments' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /comments/:id
  describe 'GET /comments/:id.json' do
    before { get "/comments/#{comment_id}.json" }

    context 'when the record exists' do
      it 'returns the comments' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/no comment found for this id/)
      end
    end
  end

  # # Test suite for POST /comments
  # describe 'POST /comments.json' do
  #   # valid payload
  #   let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }
  #
  #   context 'when the request is valid' do
  #     before { post '/comments.json', params: valid_attributes }
  #
  #     it 'creates a comment' do
  #       expect(json['title']).to eq('Learn Elm')
  #     end
  #
  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end
  #
  #   context 'when the request is invalid' do
  #     before { post '/comments.json', params: { title: 'Foobar' } }
  #
  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end
  #
  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match(/Validation failed: Created by can't be blank/)
  #     end
  #   end
  # end

  # Test suite for PUT /comments/:id
  describe 'PUT /comments/:id.json' do
    let(:valid_attributes) { {comment: { body: 'changed comment text' }} }

    context 'when the record exists' do
      before do
        put "/comments/#{comment_id}.json", params: valid_attributes, headers: {Token: "token#1"}
      end

      it 'updates the record' do
        expect(json["body"]).to eq(valid_attributes[:comment][:body])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # # Test suite for DELETE /comments/:id
  # describe 'DELETE /comments/:id.json' do
  #   before { delete "/comments/#{comment_id}.json" }
  #
  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end
