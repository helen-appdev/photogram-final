class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")
    
    recipient_username = params.fetch("query_username")

    recipient = User.where({:id => params.fetch("query_recipient_id")}).at(0)

    if the_follow_request.valid?
      the_follow_request.save
      
      
      if recipient.private == true
        redirect_to("/", { :notice => "You're not authorized for that." })
      else
      redirect_to("/users/#{recipient_username}", { :notice => "Follow request created successfully." })
      end
    else
      redirect_to("/follow_requests", { :notice => "Follow request failed to create successfully." })
    end
  end

  # def update
  #   the_id = params.fetch("path_id")
  #   the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

  #   the_follow_request.recipient_id = params.fetch("query_recipient_id")
  #   the_follow_request.sender_id = params.fetch("query_sender_id")
  #   the_follow_request.status = params.fetch("query_status")

  #   if the_follow_request.valid?
  #     the_follow_request.save
  #     redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
  #   else
  #     redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => "Follow request failed to update successfully." })
  #   end
  # end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.destroy

    redirect_to("/follow_requests", { :notice => "Follow request deleted successfully."} )
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)
    the_follow_request.status = params.fetch("query_status")
    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{@current_user.username}", { :notice => "Follow request accepted."} )
    else
      redirect_to("/follow_requests/#{@current_user.username}", { :alert => "Follow request failed to accept." })
    end

  end


end
