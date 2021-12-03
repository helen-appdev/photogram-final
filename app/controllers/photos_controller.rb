class PhotosController < ApplicationController
  def index
    public_users = User.where.not({:private => true})
    read_public_users = Array.new
      public_users.each do |one|
        read_public_users.push(one.id)
      end

    matching_photos = Photo.where({:owner_id => read_public_users})
    @list_of_photos = matching_photos.order({ :created_at => :desc })
    @users = User.all

    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)
    
    @owner = User.where({:id => @the_photo.owner_id}).at(0)
    likes_list = Like.where({:photo_id => @the_photo.id})
    likers = Array.new
      likes_list.each do |liker|
        likers.push(liker.fan_id)
      end
    @fans = User.where({:id => likers})

    render({ :template => "photos/show.html.erb" })
  end

  def create
    the_photo = Photo.new
    the_photo.image = params.fetch("image")  #had colon as query_image, the_photo was image2
    the_photo.caption = params.fetch("query_caption")
    the_photo.owner_id = params.fetch("query_owner_id")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.comments_count = params.fetch("query_comments_count")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :notice => "Photo failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.image = params.fetch("query_image")
    the_photo.caption = params.fetch("query_caption")
    # the_photo.owner_id = params.fetch("query_owner_id")
    # the_photo.likes_count = params.fetch("query_likes_count")
    # the_photo.comments_count = params.fetch("query_comments_count")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => "Photo failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
