class UsersController < ApplicationController
  def discover
    the_username = params.fetch("username")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    @following = FollowRequest.where({:sender_id => @the_user.id, :status => "accepted"})
    
    the_followed = Array.new
      @following.each do |person|
        the_followed.push(person.recipient_id)
        end
      
    #this is wrong, needs to become the posts liked by ppl the user is following.. make photo user
    discover_likes = Like.where({:fan_id => the_followed})
    discover_posts = Array.new
      discover_likes.each do |person|
        discover_posts.push(person.photo_id)
      end

    @discover_photos = Photo.where({:id => discover_posts})
    
    
      
    render({:template => "users/discover.html.erb"})
  end
  
  
  def feed
    the_username = params.fetch("username")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    @following = FollowRequest.where({:sender_id => @the_user.id, :status => "accepted"})
    
    the_followed = Array.new
      @following.each do |person|
        the_followed.push(person.recipient_id)
        end
      
    @following_posts = Photo.where({:owner_id => the_followed})
      
    render({:template => "users/feed.html.erb"})
  end
  
  def liked_photos
    
    the_username = params.fetch("path_id")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    
    likes = Like.where({:fan_id => @the_user.id})
    photo_ids = Array.new
      likes.each do |one|
        photo_ids.push(one.photo_id)
      end
    @liked_photos = Photo.where({:id => photo_ids})
      render({:template => "users/liked_photos.html.erb"})

    
  end
  
  
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :username => :asc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_username = params.fetch("path_id")

    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)

    @follow = FollowRequest.where({:recipient_id => @the_user.id, :status => "pending"})
    
    requests = Array.new
    @follow.each do |this|
      requests.push(this.sender_id)
    end

    @requesters = User.where({:id => requests})


    @follow_status = FollowRequest.where({:recipient_id => @the_user.id, :status => "accepted", :sender_id => @current_user.id}).at(0)

    if @the_user.private == false || @follow_status != nil || @the_user == @current_user
      render({ :template => "users/show.html.erb" })
    else
      redirect_to("/", { :alert => "You're not authorized for that." })
    end
  end

  def create
    the_user = User.new
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.email = params.fetch("query_email")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.password_digest = params.fetch("query_password_digest")
    the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User created successfully." })
    else
      redirect_to("/users", { :notice => "User failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.email = params.fetch("query_email")
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")
    the_user.password_digest = params.fetch("query_password")
    
  
    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => "User failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end

end
