class ApiController < ApplicationController
  def index
  	print params
  	if params[:query].split(":")[0]=="graph"
  		params[:query] = params[:query].split(":")[1]
  		results = {}
	  	results["query"] = "Unit"
	  	input_words = params[:query].split(" ")
	  	city = input_words[input_words.length - 1]
	  	study = input_words[input_words.length - 1]
  		results = {}
  		results["query"] = "Unit"
	  	top_5 = []
	  	if (input_words.include? "friends" or input_words.include? "friend") and input_words.include? "live"
	  		array = PersonalInformation.find_by_sql("select * from personal_informations where city like \""+city+"%\"")
	  		names = []
		  	for x in array
		  		a = User.find(x.user_id)
		  		if Friend.where(:user1 => a.id,:user2 => cookies[:user_id])[0]==nil
		  			next
		  		end
		  		temp_hash ={}
		  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
		  		
		  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
		  		temp_hash["value"] = div
		  		temp_hash["data"] = div
		  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
		  		names << temp_hash
		  	end
		  	results["suggestions"] = names[0,5]
	  	elsif input_words.include? "people" and input_words.include? "live"
	  		array = PersonalInformation.find_by_sql("select * from personal_informations where city like \""+city+"%\"")
	  		names = []
		  	for x in array
		  		a = User.find(x.user_id)
		  		temp_hash ={}
		  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
		  		
		  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
		  		temp_hash["value"] = div
		  		temp_hash["data"] = div
		  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
		  		names << temp_hash
		  	end
		  	results["suggestions"] = names[0,5]
		  elsif (input_words.include? "friends" or input_words.include? "friend") and input_words.include? "study"
	  		array = PersonalInformation.find_by_sql("select * from personal_informations where university like \""+study+"%\"")
	  		names = []
		  	for x in array
		  		a = User.find(x.user_id)
		  		if Friend.where(:user1 => a.id,:user2 => cookies[:user_id])[0]==nil
		  			next
		  		end
		  		temp_hash ={}
		  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
		  		
		  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
		  		temp_hash["value"] = div
		  		temp_hash["data"] = div
		  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
		  		names << temp_hash
		  	end
		  	results["suggestions"] = names[0,5]
	  	elsif input_words.include? "people" and input_words.include? "study"
	  		array = PersonalInformation.find_by_sql("select * from personal_informations where university like \""+study+"%\"")
	  		names = []
		  	for x in array
		  		a = User.find(x.user_id)
		  		temp_hash ={}
		  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
		  		
		  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
		  		temp_hash["value"] = div
		  		temp_hash["data"] = div
		  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
		  		names << temp_hash
		  	end
		  	results["suggestions"] = names[0,5]
	  	end
  		render json: results
  	elsif params[:query].split(":")[0]=="question"
  		params[:query] = params[:query].split(":")[1]
  		@questions = Question.all
  		results = {}
	  	results["query"] = "Unit"
	  	top_5 = []
	  	input_words = params[:query].split(" ")
	  	print input_words
	  	for question in @questions
	  		
	  		question_title = question.title.split(" ")
	  		question_tags = []
	  		temp = question.question_tags
	  		for t in temp 
	  			question_tags << t.tag_name
	  		end
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
	  	render json: results
	elsif params[:query].split(":")[0]=="group"
  		array = Group.find_by_sql("select * from groups where name like \""+params[:query].split(":")[1]+"%\"")
	  	results = {}
	  	results["query"] = "Unit"
	  	names = []
	  	for a in array
	  		temp_hash ={}
	  		 div = '<div style="background-color:aliceblue;padding:10px;"><h5><i class="glyphicon glyphicon-tree-conifer"></i>  ' + a.name+'</h5></div> '
	  		temp_hash["value"] = div
	  		temp_hash["data"] = div
	  		temp_hash["link"] = "/groups/"+a.id.to_s
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  	render json: results
  	else
	  	array = User.find_by_sql("select * from users where fname like \""+params[:query]+"%\"")
	  	results = {}
	  	results["query"] = "Unit"
	  	names = []
	  	for a in array
	  		temp_hash ={}
	  		image = '<img src="'+a.profile_pic(:thumb)+'" width="42" height="42">'
	  		
	  		div = '<div style="background-color:aliceblue;padding:10px;">'+image+'<h5>'+ a.fname + " " + a.lname+ '</h5></div>'
	  		temp_hash["value"] = div
	  		temp_hash["data"] = div
	  		temp_hash["link"] = "/main/profile?id="+a.id.to_s
	  		names << temp_hash
	  	end
	  	results["suggestions"] = names
	  
	  	render json: results
	end
  end
end
