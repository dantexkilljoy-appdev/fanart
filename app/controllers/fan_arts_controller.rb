class FanArtsController < ApplicationController
  require "openai"

  def home
    render({ template: "fan_arts/home.html.erb" })
  end

  def index
    matching_fan_arts = FanArt.all

    @list_of_fan_arts = matching_fan_arts.where({ user_id: @current_user }).order({ :created_at => :desc })

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

      client = OpenAI::Client.new(access_token: ENV["API_TOKEN"])

      @response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [{ role: "system", content: "You are a #{@the_fan_art.topic} fanatic. Give the user an #{@the_fan_art.topic} character. Keep it one sentence and do not use quotes." },
                     { role: "user", content: "What #{@the_fan_art.topic} characters should I draw?" }],
          temperature: 1.0,
        },
      )

      @result = @response.fetch("choices").at(0).fetch("message").fetch("content")

      @assistant_message = Message.new
      @assistant_message.fan_art_id = @the_fan_art.id
      @assistant_message.role = "assistant"
      @assistant_message.content = @response.fetch("choices").at(0).fetch("message").fetch("content")
      @assistant_message.user_id = @current_user.id
      @assistant_message.save

      redirect_to("/fan_arts/#{@the_fan_art.id}", { :notice => "Fan art generated." })
    else
      redirect_to("/fan_arts/#{@the_fan_art.id}", { :alert => @the_fan_art.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_fan_art = FanArt.where({ :id => the_id }).at(0)

    the_fan_art.topic = params.fetch("query_topic")
    the_fan_art.user_id = params.fetch("query_user_id")

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
