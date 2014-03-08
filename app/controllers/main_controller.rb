class MainController < ApplicationController
require "httparty"
require 'digest/md5'
 require 'securerandom'
 def update
 	@user = Users.find(cookies[:user_id])
 end
 
 
 def manageFriends
 	if params[:status] == "Add friend"
 		new_friend = PendingFriend.new
 		new_friend.user1 = cookies[:user_id]
 		new_friend.user2 = params[:id]
 		new_friend.save
 	elsif params[:status] == "accept"
 		new_friend = Friend.new
 		new_friend.user1 = cookies[:user_id]
 		new_friend.user2 = params[:id]
 		new_friend.save
 		new_friend = Friend.new
 		new_friend.user2 = cookies[:user_id]
 		new_friend.user1 = params[:id]
 		new_friend.save
 		PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0].destroy
 	elsif params[:status] == "cancel friend request"
 		PendingFriend.find_by_sql("select * from pending_friends where user1=\""+cookies[:user_id]+"\" and user2="+params[:id])[0].destroy
 	elsif params[:status] == "cancel others friend requests"
 		PendingFriend.find_by_sql("select * from pending_friends where user2=\""+cookies[:user_id]+"\" and user1="+params[:id])[0].destroy
 	else
 		Friend.find_by_sql("select * from friends where user1="+params[:id]+" and user2="+cookies[:user_id])[0].destroy
 		Friend.find_by_sql("select * from friends where user2="+params[:id]+" and user1="+cookies[:user_id])[0].destroy
 	end
 	if params[:check]
 		redirect_to action: "profile"
 	else
 		redirect_to action: "profile", id: params[:id]
 	end

 end
  def profile
  	
  	if params[:id]
  		@user = User.find_by_sql("select * from users where id="+params[:id])
  		if @user==nil
  			redirect_to action: "profile"
  		else
  			@user = @user[0]
  			if Friend.find_by_sql("select * from friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				@status = "unfriend"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1=\""+cookies[:user_id]+"\" and user2="+params[:id])[0]!=nil
  				@status = "cancel friend request"
  			elsif PendingFriend.find_by_sql("select * from pending_friends where user1="+params[:id]+" and user2=\""+cookies[:user_id]+"\"")[0]!=nil
  				@status = "accept"
  			else
  				@status = "Add friend"
  			end	 	 
  		end
  	else
	  	@questions = Question.find_by_sql("select * from questions")
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
		 elsif cookieCheck==0
		 	redirect_to action: "index"
		 end
		 if cookieCheck==1
		 	@temp = PendingFriend.where(:user2 => cookies[:user_id])
		 	@friend_requests=[]
		 	for temp in @temp
		 		 @friend_requests << User.find(temp.user1)
		 	end
		 end
	end
  end
  def logout
  	cookies.delete :user_name
  	cookies.delete :user_id
  	redirect_to action: "index"
  end
  def cookieCheck
  		if cookies[:user_name]!=nil
  			return 1
  		else
  			return 0
  		end
  end
  def index
  	@error_login = params[:error_login]
  	if cookieCheck==1
  		redirect_to action: "profile"
  	end
  end
  def confirm
  	@passcode  = params[:passcode]
  	@error = "hello"
  	if @passcode!=nil
  		@error ="hii"
  		user = NonVerifiedUser.find_by_sql("SELECT * from non_verified_users where passcode=\""+@passcode+"\" and email=\""+params[:email]+"\"")
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
	  	user = User.find_by_sql("select * from non_verified_users where email=\""+params[:email]+"\"")
	  	if user[0]!=nil
	  		@error = "user already exists"
	  	end
	  	user = User.find_by_sql("select * from users where email=\""+params[:email]+"\"")
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
