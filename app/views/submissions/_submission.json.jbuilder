json.extract! submission, :id, :title, :url, :text, :user_id, :created_at, :updated_at
json.points submission.cached_votes_score
json.location submission_url(submission, format: :json)
json.comment_number submission.comments.count
