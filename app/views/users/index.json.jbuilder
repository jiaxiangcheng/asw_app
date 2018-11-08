json.array!(@users) do |user|
  json.extract! user, :id, :email, :name, :about, :created_at, :updated_at
  json.set! "_links" do
    json.set! "self" do
      json.set! "href", user_url(user, format: :json)
    end
  end
end

