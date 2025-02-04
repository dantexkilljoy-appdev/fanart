class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    render({ :template => "photos/show.html.erb" })
  end

  def create
    the_photo = Photo.new
    the_photo.fan_art_id = params.fetch("query_fan_art_id")
    the_photo.owner_id = params.fetch("query_owner_id")
    the_prompt = params.fetch("query_prompt")
    client = OpenAI::Client.new(access_token: ENV["API_TOKEN"])

    response = client.images.generate(parameters: { prompt: the_prompt, size: "256x256" })

    # TODO: download image at this url
    the_photo.remote_image_url = response.fetch("data").at(0).fetch("url")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo generated." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.fan_art_id = params.fetch("query_fan_art_id")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully." })
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully." })
  end
end
