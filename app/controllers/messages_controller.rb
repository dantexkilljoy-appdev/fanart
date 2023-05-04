class MessagesController < ApplicationController
  def create
    the_message = Message.new
    the_message.role = params.fetch("query_role")
    the_message.content = params.fetch("query_content")
    the_message.fan_art_id = params.fetch("query_fan_art_id")
    the_message.user_id = params.fetch("query_user_id")

    if the_message.valid?
      the_message.save

      the_idea = FanArt.where({ :id => the_message.fan_art_id }).at(0)

      client = OpenAI::Client.new(access_token: ENV.fetch("API_TOKEN"))

      api_messages_array = Array.new

      fan_art_messages = Message.where({ :fan_art_id => the_idea.id }).order(:created_at)

      fan_art_messages.each do |the_message|
        message_hash = { :role => the_message.role, :content => the_message.content }

        api_messages_array.push(message_hash)
      end

      @response = client.chat(
        parameters: {
          model: ENV.fetch("API_TOKEN"),
          messages: api_messages_array,
          temperature: 1.0,
        },
      )

      assistant_message = Message.new
      assistant_message.fan_art_id = the_message.fan_art_id
      assistant_message.role = "assistant"
      assistant_message.content = response.fetch("message").fetch("content")
      assistant_message.save

      redirect_to("/messages", { :notice => "Message created successfully." })
    else
      redirect_to("/messages", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end
end
