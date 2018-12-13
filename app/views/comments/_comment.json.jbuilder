json.extract! comment, :id, :submission_id, :body, :user_id, :created_at, :updated_at
json.location comment_url(comment, format: :json)
