class MainController < ApplicationController
require "httparty"
require 'digest/md5'
 require 'securerandom'
 layout 'application', :except => "index"
 before_action :cookieCheck, only: [:index]
 def cookieCheck
      temp = CookieCheck.where(:user_id => cookies[:user_id])[0]
      if cookies[:user_id]!=nil and temp!=nil
        if temp.checksum.to_s == cookies[:checksum].to_s
          return 1
        end
      end
      if cookies[:user_id]!=nil
        logout
      end
      return 0
  end
 def update
 	@user = Users.find(cookies[:user_id])
 end
def FriendRequests
  	new_hash = {}
  	print params
  	if params[:status]=="confirm_request"
  		new_friend = Friend.new
 		new_friend.user1 = params[:user1]
 		new_friend.user2 = params[:user2]
 		new_friend.save
 		new_friend = Friend.new
 		new_friend.user2 = params[:user1]
 		new_friend.user1 = params[:user2]
 		new_friend.save
 		PendingFriend.where( :user1=>  params[:user1], :user2 => params[:user2])[0].destroy
  	elsif params[:status]=="cancel_request"
  		PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:user1]+" and user2=\""+params[:user2]+"\"")[0].destroy
  	end
  	new_hash["result"] = 1
  	render json: new_hash
  end
def like_p
	@new_hash = {}
	if WallPostLike.find_by_sql("select * from wall_post_likes where wall_post_id="+params[:post_id]+" and liked_by="+params[:current_user_id])[0]==nil
		find_post = WallPost.find(params[:post_id])
 		find_post.likes = find_post.likes + 1 
 		find_post.save
 		new_like = WallPostLike.new
 		new_like.liked_by = cookies[:user_id]
 		new_like.wall_post_id = params[:post_id]
 		new_like.save
 		@new_hash["result"] = 1
 		@new_hash["likes"] = find_post.likes
 	else
 		WallPostLike.find_by_sql("select * from wall_post_likes where wall_post_id="+params[:post_id]+" and liked_by="+params[:current_user_id])[0].destroy
 		find_post = WallPost.find(params[:post_id])
 		find_post.likes = find_post.likes - 1 
 		find_post.save
 		@new_hash["result"] = 0
 		@new_hash["likes"] = find_post.likes
 		
 	end
 	render json: @new_hash
end

 def like_post
 	if params[:is_liked]=="like"
 		new_like = WallPostLike.new
 		new_like.liked_by = cookies[:user_id]
 		new_like.wall_post_id = params[:post_id]

 		find_post = WallPost.find(params[:post_id])
 		find_post.likes = find_post.likes + 1 
 		find_post.save
 		new_like.save
 	else
 		WallPostLike.find_by_sql("select * from wall_post_likes where wall_post_id="+params[:post_id]+" and liked_by="+cookies[:user_id])[0].destroy
 		find_post = WallPost.find(params[:post_id])
 		find_post.likes = find_post.likes - 1 
 		find_post.save
 	end
 	if params[:id]==cookies[:user_id]
 		redirect_to action: "profile"
 	else
 		redirect_to action: "profile", id: params[:id]
 	end
 end
 def like_comment
 	if params[:is_liked]=="like"
 		new_like = WallCommentLike.new
 		new_like.liked_by = cookies[:user_id]
 		new_like.wall_comment_id = params[:comment_id]

 		find_comment = WallPostComment.find(params[:comment_id])
 		find_comment.likes = find_comment.likes + 1 
 		find_comment.save
 		new_like.save
 	else
 		WallCommentLike.find_by_sql("select * from wall_comment_likes where wall_comment_id="+params[:comment_id]+" and liked_by="+cookies[:user_id])[0].destroy
 		find_comment = WallPostComment.find(params[:comment_id])
 		find_comment.likes = find_comment.likes - 1 
 		find_comment.save
 	end
 	if params[:id]==cookies[:user_id]
 		redirect_to action: "profile"
 	else
 		redirect_to action: "profile", id: params[:id]
 	end
 end
 def post_submit
 	if params[:content]!=""
 		new_post = WallPost.new
 		new_post.content = params[:content]
 		new_post.from_id = cookies[:user_id]
 		new_post.to_id 	= params[:id]
 		new_post.likes = 0
 		new_post.save
 	end
 	if params[:id]==cookies[:user_id]
 		redirect_to action: "profile"
 	else
 		redirect_to action: "profile", id: params[:id]
 	end
 end
 def forgotpassword
    if params[:email]
      url = "https://sendgrid.com/api/mail.send.json"
          random_number = SecureRandom.hex(15)
          user = User.where(:email => params[:email])[0]
          if user
            response = HTTParty.post url, :body => {
              "api_user" => "stranger9811",
              "api_key" => "SecretPassword",
              "to" => params[:email],
              "from" => "dbms@sendgrid.me",
              "subject" => "Email Verfication for DBMS_project",
              "text" => "New password ="+random_number
            }
          end
          user.password = Digest::MD5.hexdigest(random_number)
          user.save

    end
 end
 def updateinfo
    print "gender ",params[:Gender] 
    @q = PersonalInformation.where(:user_id => cookies[:user_id])
    @q = @q[0]
    if @q==nil
      @q =PersonalInformation.new
      @q.user_id = cookies[:user_id]
    end
    @q.gender = params[:Gender]
    @q.birthday = params[:Birthday]
    @q.city = params[:City]
    @q.university = params[:University]
    @q.phone = params[:Phone]
    @q.save
    redirect_to action: "editprofile"
 end
 def updateinfo2
    user = User.find(cookies[:user_id])
    if (params[:newpassword]) and (params[:newpassword]==params[:repassword])
        oldpassword = Digest::MD5.hexdigest(params[:oldpassword])
        if oldpassword==user.password
            user.password= Digest::MD5.hexdigest(params[:newpassword])
        end
    end
    if params[:fname] and params[:lname]
      user.fname  = params[:fname]
      user.lname  = params[:lname]
    end
    user.save
    redirect_to action: "editprofile"
 end
 def add_comment
 	if params[:comment]!=""
      new_comment = WallPostComment.new
      new_comment.added_by = cookies[:user_id]
      new_comment.comment = params[:comment]
      new_comment.wall_post_id = params[:post_id]
      new_comment.likes = 0
      new_comment.save
    end
    if params[:id]==cookies[:user_id]
 		redirect_to action: "profile"
 	else
 		redirect_to action: "profile", id: params[:id]
 	end
 end
 def friends
  if params[:friend]
    @all_friends = Friend.where(:user1 => params[:friend])
  else
 	  @all_friends = Friend.where(:user1 => cookies[:user_id])
  end
 end
 def add_messages
 	@message = Message.new
 	if params[:content]
 		@message.user_from = cookies[:user_id]
 		@message.user_to = params[:id]
 		@message.content = params[:content]
 		@message.status = "unread"
 		@message.save
 	end

 	redirect_to action: "messages", id: params[:id]
 end
 def editprofile
    @q = PersonalInformation.where(:user_id => cookies[:user_id])
    @q = @q[0]
    if @q==nil
      @q =PersonalInformation.new
      @q.user_id = cookies[:user_id]
      @q.gender = "Male"
      @q.save
    end
 end

 def messages
 	@all_friends = Friend.where(:user1 => cookies[:user_id])
 	@first_friend = ""
 	for friend in @all_friends
 		@first_friend = User.find(friend.user2)
 		break
 	end
 end
 def manageFriends
 	output = {}
 	output["result"] = 0
 	if $status == "Add_friend"
 		new_friend = PendingFriend.new
 		new_friend.user1 = cookies[:user_id]
 		new_friend.user2 = params[:id]
 		new_friend.save
 		output["status"] = "cancel friend request"
 		$status = "cancel_friend_request"
 	elsif $status == "accept"
 		new_friend = Friend.new
 		new_friend.user1 = cookies[:user_id]
 		new_friend.user2 = params[:id]
 		new_friend.save
 		new_friend = Friend.new
 		new_friend.user2 = cookies[:user_id]
 		new_friend.user1 = params[:id]
 		new_friend.save
 		$status = "unfriend"
 		output["status"] = "unfriend"
 		PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0].destroy
 	elsif $status == "cancel_friend_request"
 		$status = "Add_friend"
 		output["status"] = "Add Friend"
 		PendingFriend.find_by_sql("select * from pending_friends where user1=\""+cookies[:user_id]+"\" and user2="+params[:id])[0].destroy
 	elsif $status == "cancel others friend requests"
 		PendingFriend.find_by_sql("select * from pending_friends where user2=\""+cookies[:user_id]+"\" and user1="+params[:id])[0].destroy
 	else
 		$status = "Add_friend"
 		output["status"] = "Add Friend"
 		Friend.find_by_sql("select * from friends where user1="+params[:id]+" and user2="+cookies[:user_id])[0].destroy
 		Friend.find_by_sql("select * from friends where user2="+params[:id]+" and user1="+cookies[:user_id])[0].destroy
 	end
 	
 	
 	output["result"] = 1
 	render json: output
 end
 def profile2
  	if params[:id]==cookies[:user_id]
  		params[:id] = nil
  	end
  	$color = "pink"
  	@style = "background-color: red; width: 25em;padding-top:5px;padding-left:5px;padding-bottom:5px;padding-right:5px;"
  	if params[:id]
  		@user = User.find_by_sql("select * from users where id="+params[:id])
  		if @user[0]==nil
  			redirect_to action: "profile"
  		else
  			@my_posts = WallPost.find_by_sql("select * from wall_posts where to_id="+params[:id])
  			@user = @user[0]
  			if Friend.find_by_sql("select * from friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				$status = "unfriend"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1=\""+cookies[:user_id]+"\" and user2="+params[:id])[0]!=nil
  				$status = "cancel_friend_request"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				$status = "accept"
  			else
  				$status = "Add_friend"
  			end	 	 
  		end
  	else
  		
	  	if params[:password] and params[:email]
		  	@error=""
		  	password = Digest::MD5.hexdigest(params[:password])
		  	email = params[:email]
		  	@user = User.find_by_sql("SELECT * from users where password=\""+password+"\" and email=\""+email+"\"")
		  	@user = @user[0]
		  	if @user==nil
		  		redirect_to action: "index", error_login: "user not registered/ wrong password"
		  	else
		  		@name = @user.fname
		  		cookies[:user_name]=@name
		  		cookies[:user_id]=@user.id
		  	end
		 end
		 	@friend_requests = PendingFriend.where(:user2 => cookies[:user_id])
      @my_posts = WallPost.find_by_sql("select * from wall_posts where to_id="+cookies[:user_id].to_s)
	end
	
  end
  def profile
  	if params[:id]==cookies[:user_id]
  		params[:id] = nil
  	end
    @user = nil
    if cookies[:user_id]
      @user = User.find(cookies[:user_id])
    end
  	$color = "pink"
  	if params[:id]
  		@user = User.find_by_sql("select * from users where id="+params[:id])
  		if @user[0]==nil
  			redirect_to action: "profile"
  		else
  			@my_posts = WallPost.find_by_sql("select * from wall_posts where to_id="+params[:id])
  			@user = @user[0]
  			if Friend.find_by_sql("select * from friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				$status = "unfriend"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1=\""+cookies[:user_id]+"\" and user2="+params[:id])[0]!=nil
  				$status = "cancel_friend_request"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				$status = "accept"
  			else
  				$status = "Add_friend"
  			end	 	 
  		end
  	else
  		
	  	if params[:password] and params[:email]
		  	@error=""
		  	password = Digest::MD5.hexdigest(params[:password])
		  	email = params[:email]
		  	@user = User.where(:password => password, :email =>email)[0]
		    print email
		  	if @user==nil
		  		redirect_to action: "index", error_login: "user not registered/ wrong password"
		  	else
		  		@name = @user.fname
		  		cookies[:user_name]=@name
		  		cookies[:user_id]=@user.id
          random_number = SecureRandom.hex(15)
          cookies[:checksum] = random_number
          temp =CookieCheck.where(:user_id => cookies[:user_id])[0]
          if temp!=nil
            temp.checksum = random_number.to_s
            temp.save
          else
            x = CookieCheck.new
            x.user_id = cookies[:user_id]
            x.checksum = random_number.to_s
            x.save
          end

		  	end
		 end
     if @user!=nil
		 	@friend_requests = PendingFriend.where(:user2 => cookies[:user_id])
      @my_posts = WallPost.find_by_sql("select * from wall_posts where to_id="+cookies[:user_id].to_s)
    end
		 
	end
	
  end
  def logout
    temp = CookieCheck.where(:user_id => cookies[:user_id])[0]
    if temp!=nil
      temp.destroy
    end
  	cookies.delete :user_name
  	cookies.delete :user_id
    cookies.delete  :checksum
  	redirect_to action: "index"
    
  end
  
  def index
  	@error_login = params[:error_login]
  	if cookies[:user_id]!=nil
  		redirect_to action: "profile"
  	end
  end
  def confirm
  	@passcode  = params[:passcode]
  	@error = "hello"
  	if @passcode!=nil
  		@error ="hii"
  		user = NonVerifiedUser.where(:passcode => @passcode, :email => params[:email])
  		user_current = user[0]
  		if user_current == nil
  			@error = "wrong verification link"
  		else

	  		new_user = User.new
			new_user.fname = user_current.fname
		    new_user.lname = user_current.lname
		    new_user.email = user_current.email
		    new_user.password = user_current.password
		    new_user.save
		    user_current.delete
		    @error = "email verified"
		    redirect_to action: "index"
	    end

  	else
	  	@error = "no error"
	  	regular_exp = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
	  	@check = regular_exp.match(params[:email])
	  	if @check==nil
	  		@error = "invalid email"
	  	end
	  	if params[:fname] == "" or params[:lname] =="" or params[:email] =="" or params[:password] ==""
	  		@error = "All entries must be filled"
	  	end

	  	if params[:password]!=params[:repassword]
	  		@error = "password do not match"
	  	end
	  	user = NonVerifiedUser.where(:email => params[:email])
	  	if user[0]!=nil
	  		@error = "user already exists"
	  	end
	  	user = User.where(:email =>params[:email])
	  	if user[0]!=nil
	  		@error = "user already exists"
	  	end
	  	if @error=="no error"
	  		
	  		password_hash = Digest::MD5.hexdigest(params[:password])
	  		random_number = SecureRandom.hex(15)
	  		url = "https://sendgrid.com/api/mail.send.json"

	      	response = HTTParty.post url, :body => {
	        	"api_user" => "stranger9811",
	        	"api_key" => "SecretPassword",
	        	"to" => params[:email],
	        	"from" => "dbms@sendgrid.me",
	        	"subject" => "Email Verfication for DBMS_project",
	        	"text" => "http://localhost:3000/main/confirm?passcode="+random_number+"&"+"email="+params[:email]
	      	}
	      	non_verified_user = NonVerifiedUser.new
	      	non_verified_user.fname = params[:fname]
	      	non_verified_user.lname = params[:lname]
	      	non_verified_user.email = params[:email]
	      	non_verified_user.password = password_hash
	      	non_verified_user.passcode = random_number
	      	non_verified_user.save
	      	redirect_to action: "index"
	  	end
	  end
	end
end
