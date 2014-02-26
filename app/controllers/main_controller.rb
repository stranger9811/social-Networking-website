class MainController < ApplicationController
require "httparty"
require 'digest/md5'
 	require 'securerandom'
  def profile
  	@error=""
  	password = Digest::MD5.hexdigest(params[:password])
  	email = params[:email]
  	@user = Users.find_by_sql("SELECT * from users where password=\""+password+"\" and email=\""+email+"\"")
  	@user = @user[0]
  	if @user==nil
  		redirect_to action: "index", error_login: "user not registered/ wrong password"
  	else
  		@name = @user.fname
  	end
  end

  def index
  	@error_login = params[:error_login]
  end
  def confirm
  	@passcode  = params[:passcode]
  	if @passcode!=nil
  		user = Users.find_by_sql("SELECT * from non_verified_users where passcode=\""+@passcode+"\" and email=\""+params[:email]+"\"")
  		user = user[0]
  		if user == nil
  			@error = "wrong verification link"
  		else
	  		new_user = Users.new
			new_user.fname = user.fname
		    new_user.lname = user.lname
		    new_user.email = user.email
		    new_user.password = user.password
		    new_user.save
		    @error = "email verified"
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
	  	user = Users.find_by_sql("select * from non_verified_users where email=\""+params[:email]+"\"")
	  	if user[0]!=nil
	  		@error = "user already exists"
	  	end
	  	user = Users.find_by_sql("select * from users where email=\""+params[:email]+"\"")
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
	  	end
	  end
	end
end
