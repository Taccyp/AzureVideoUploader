json.array!(@tags) do |tag|
  json.extract! tag, :id, :description
  json.url tag_url(tag, format: :json)
end
