json.extract! submission, :id, :title, :url, :text, :user_id, :created_at, :updated_at
json.url submission_url(submission, format: :json)
