class ApiController < ApplicationController
  def index
  	print params
  	if params[:query].split(":")[0]=="page"
  		array = Page.find_by_sql("select * from pages where title like \""+params[:query].split(":")[1]+"%\"")
	  	results = {}
	  	results["query"] = "Unit"
	  	names = []
	  	for a in array
	  		temp_hash ={}
	  		image = '<img src="/images/ashok.jpg"  width="42" height="42">'
	  		temp_hash["value"] = a.title
	  		temp_hash["data"] = a.title
	  		temp_hash["link"] = "/pages/"+a.id.to_s
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  	print results
	  	render json: results
  	else
	  	array = User.find_by_sql("select * from users where fname like \""+params[:query]+"%\"")
	  	results = {}
	  	results["query"] = "Unit"
	  	names = []
	  	for a in array
	  		temp_hash ={}
	  		image = '<img src="/images/ashok.jpg"  width="42" height="42">'
	  		temp_hash["value"] = a.fname
	  		temp_hash["data"] = a.lname
	  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  	print results
	  	render json: results
	end
  end
end
