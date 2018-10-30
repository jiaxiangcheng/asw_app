json.extract! news, :id, :title, :site, :body, :points, :author, :num_comments, :is_voted, :created_at, :updated_at
json.url news_url(news, format: :json)
