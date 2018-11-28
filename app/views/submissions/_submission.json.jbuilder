json.extract! submission, :id, :title, :url, :text, :user_id, :created_at, :updated_at
json.points submission.cached_votes_score
json.url submission_url(submission, format: :json)
