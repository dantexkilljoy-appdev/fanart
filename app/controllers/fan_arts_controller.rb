class FanArtsController < ApplicationController
  def home
    render({ template: "fan_arts/home.html.erb" })
  end

  def index
    matching_fan_arts = FanArt.all

    @list_of_fan_arts = matching_fan_arts.order({ :created_at => :desc })

    render({ :template => "fan_arts/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_fan_arts = FanArt.where({ :id => the_id })

    @the_fan_art = matching_fan_arts.at(0)

    render({ :template => "fan_arts/show.html.erb" })
  end

  def create
    @the_fan_art = FanArt.new
    @the_fan_art.topic = params.fetch("query_topic")
    @the_fan_art.user_id = params.fetch("query_user_id")

    if @the_fan_art.valid?
      @the_fan_art.save

      system_message = Message.new
      system_message.fan_art_id = @the_fan_art.id
      system_message.role = "system"
      system_message.content = "You are a #{@the_fan_art.topic} fanatic. Give the user a drawing project idea based on #{@the_fan_art.topic} that will include random #{@the_fan_art.topic} characters doing anything."
      system_message.save

      user_message = Message.new
      user_message.fan_art_id = @the_fan_art.id
      user_message.role = "user"
      user_message.content = "What #{@the_fan_art.topic} characters should I draw?"
      user_message.save

      client = OpenAI::Client.new

      api_messages_array = Array.new

      fan_art_messages = Message.where({ :fan_art_id => @the_fan_art.id }).order(:created_at)

      fan_art_messages.each do |the_message|
        message_hash = { :role => the_message.role, :content => the_message.content }

        api_messages_array.push(message_hash)
      end

      @response = client.chat(
        parameters: {
          model: "gpt - 4",
          messages: [{ role: "user", content: "Hello!" }],
          temperature: 1.0,
        },
      )

      assistant_message = Message.new
      assistant_message.fan_art_id = @the_fan_art.id
      assistant_message.role = "assistant"
      # assistant_message.content = response.fetch("message").fetch("content")
      assistant_message.save

      redirect_to("/", { :notice => "Fan art created successfully." })
    else
      redirect_to("/", { :alert => @the_fan_art.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_fan_art = FanArt.where({ :id => the_id }).at(0)

    the_fan_art.topic = params.fetch("query_topic")
    the_fan_art.user_id = params.fetch("query_user_id")
    the_fan_art.photos_count = params.fetch("query_photos_count")

    if the_fan_art.valid?
      the_fan_art.save
      redirect_to("/fan_arts/#{the_fan_art.id}", { :notice => "Fan art updated successfully." })
    else
      redirect_to("/fan_arts/#{the_fan_art.id}", { :alert => the_fan_art.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_fan_art = FanArt.where({ :id => the_id }).at(0)

    the_fan_art.destroy

    redirect_to("/fan_arts", { :notice => "Fan art deleted successfully." })
  end
end
