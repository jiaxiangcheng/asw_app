json.extract! user, :id, :name, :email, :created_at, :updated_at
json.location user_url(user, format: :json)
