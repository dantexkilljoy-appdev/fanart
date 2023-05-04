OpenAI.configure do |config|
  config.access_token = ENV.fetch("API_TOKEN")
end
