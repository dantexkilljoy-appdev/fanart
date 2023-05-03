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
    the_fan_art = FanArt.new
    the_fan_art.topic = params.fetch("query_topic")
    the_fan_art.user_id = params.fetch("query_user_id")

    if the_fan_art.valid?
      the_fan_art.save

      redirect_to("/fan_arts", { :notice => "Fan art created successfully." })
    else
      redirect_to("/fan_arts", { :alert => the_fan_art.errors.full_messages.to_sentence })
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
