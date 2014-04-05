class QuestionController < ApplicationController
  def upvote
    @answer = Answer.find(params[:id])
    @answer.upvote = @answer.upvote + 1
    @answer.save
    question_id = @answer.question_id
    redirect_to action: "view", id: question_id
  end
  def downvote
    @answer = Answer.find(params[:id])
    @answer.downvote = @answer.downvote + 1
    @answer.save
    question_id = @answer.question_id
    redirect_to action: "view", id: question_id
  end  
  def index 
    @question = Question.find(params[:id])
    @answers = Answer.find_by_sql("select * from answers where question_id="+params[:id])
    $id = params[:id]
  end
  def view 
  	@question = Question.find(params[:id])
    @answers = Answer.find_by_sql("select * from answers where question_id="+params[:id])
    $id = params[:id]
  end
  def edit
  	@question = Question.find(params[:id])
    @user = @question.added_by
    if @user.to_s != cookies[:user_id]
      redirect_to action: "view", id:params[:id]
    end  
  	$id = params[:id]
  end
  def update
  	@question = Question.find($id)
  	@question.title = params[:title]
  	@question.content = params[:content]
  	@question.save
  	redirect_to action: "view", id: @question.id
  end
  def ask
  		@name = session[:name]
  end
  def addAnswer
    if params[:your_answer]
      @question = Question.find($id)
      new_answer = @question.answers.new
      new_answer.question_id  = $id
      new_answer.content = params[:your_answer]
      new_answer.added_by = cookies[:user_id]
      new_answer.upvote = 0
      new_answer.downvote = 0
      new_answer.save
    end
    redirect_to action: "view", id: $id

  end
  def myquestions
  	@myQuestions = Question.find_by_sql("SELECT * from questions where  added_by=\""+cookies[:user_id]+"\"")
  end
  def add
  	@title = params[:title]
  	@content = params[:content]
  	@error_title=""
  	@error_content=""
  	if params[:title]==""
  		redirect_to action: "ask", error_title: "title not entered"
  	elsif params[:content]==""
  		redirect_to action: "ask", error_content: "content not entered"
  	else
  		new_question = Question.new
  		new_question.title = params[:title]
  		new_question.content = params[:content]
  		new_question.added_by = cookies[:user_id]
  		new_question.privacy = "public"
  		new_question.upvote = 0
      new_question.downvote = 0      
  		new_question.save
  		redirect_to action: "ask"
  	end
  end
end
