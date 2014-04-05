class ApiController < ApplicationController
  def index
  	print params
  	if params[:query].split(":")[0]=="question"
  		@questions = Question.all
  		results = {}
	  	results["query"] = "Unit"
	  	top_5 = []
	  	input_words = params[:query].split(" ")
	  	for question in @questions
	  		
	  		question_title = question.title.split(" ")
	  		question_tags = []
	  		temp = question.question_tags
	  		for t in temp 
	  			question_tags << t.tag_name
	  		end
	  		print question_title,question_tags,params[:query]
	  		count = 0
	  		for word in input_words
	  			if question_title.include? word
	  				count = count +1 
	  			end
	  			if question_tags.include? word
	  				count = count + 3
	  			end
	  		end
	  		if top_5.length < 5
	  			div = '<div style="background-color:aliceblue;padding:10px;"><h5><i class="glyphicon glyphicon-comment"></i>  ' + question.title+'</h5></div> '
	  			temp1  = [count,div,"/question/view?id="+question.id.to_s]
	  			top_5.append(temp1)
	  			top_5.sort
	  		elsif top_5[0][0] < count
	  			div = '<div style="background-color:aliceblue;padding:10px;"><h5><i class="glyphicon glyphicon-comment"></i>  ' + question.title+'</h5></div> '
	  			temp1  = [count,div,"/question/view?id="+question.id.to_s]
	  			top_5[0] = temp1
	  			top_5.sort
	  		end
	  	end
	  	names = []
	  	for a in top_5	
	  		temp_hash ={}
	  		temp_hash["value"] = '<b>' + a[1] + '</b>'
	  		temp_hash["data"] = a[1]
	  		temp_hash["link"] = a[2]
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  	print results
	  	render json: results

  	elsif params[:query].split(":")[0]=="page"
  		array = Page.find_by_sql("select * from pages where title like \""+params[:query].split(":")[1]+"%\"")
	  	results = {}
	  	results["query"] = "Unit"
	  	names = []
	  	for a in array
	  		temp_hash ={}
	  		 div = '<div style="background-color:aliceblue;padding:10px;"><h5><i class="glyphicon glyphicon-file"></i>  ' + a.title+'</h5></div> '
	  		temp_hash["value"] = div
	  		temp_hash["data"] = div
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
	  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
	  		print image
	  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
	  		temp_hash["value"] = div
	  		temp_hash["data"] = div
	  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  	print results
	  	render json: results
	end
  end
end
