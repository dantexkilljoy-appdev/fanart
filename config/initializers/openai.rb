OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openai, :api_token)
end
