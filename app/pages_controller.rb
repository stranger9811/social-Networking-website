class PagesController < ApplicationController
  def create

  end
  def comment
    if params[:comment]!=""
      new_comment = PostComment.new
      new_comment.added_by = cookies[:user_id]
      new_comment.comment = params[:comment]
      new_comment.post_id = params[:post_id]
      new_comment.likes = 0
      new_comment.save
    end
    redirect_to action: "show",id: $global_id
  end
  def add
  	@error_title=""
  	@error_content=""
  	if params[:title]==""
  		redirect_to action: "create", error_title: "title not entered", description: params[:description], title: params[:title]
  	elsif params[:description]==""
  		redirect_to action: "create", error_description: "description not entered", description: params[:description], title: params[:title]
  	else
  		new_page = Page.new
  		new_page.title = params[:title]
  		new_page.description = params[:description]
  		new_page.admin_id = cookies[:user_id]
  		new_page.privacy = params[:privacy]  
  		new_page.likes = 0 
  		new_page.save
  		redirect_to action: "show", id: new_page.id
  	end
  end
  def pageLike
    if params[:is_liked]=="unlike"
      PagesLike.find_by_sql("select * from pages_likes where user_id="+cookies[:user_id]+" and page_id="+$global_id.to_s)[0].destroy
      current_page = Page.find($global_id)
      current_page.likes=current_page.likes-1
      current_page.save
    else
      new_like = PagesLike.new
      new_like.user_id = cookies[:user_id]
      new_like.page_id = $global_id
      new_like.save
      current_page = Page.find($global_id)
      current_page.likes=current_page.likes+1
      current_page.save
    end
    redirect_to action: "show", id: $global_id
  end
  def show
  	begin
  		@page = Page.find(params[:id])
  		$global_id = params[:id]
      if PagesLike.find_by_sql("select * from pages_likes where user_id="+cookies[:user_id]+" and page_id="+$global_id.to_s)[0]!=nil
        @is_liked = "unlike"
      else
        @is_liked = "like"
      end
      @page_posts = PagesPost.find_by_sql("select * from pages_posts where page_id="+params[:id])
  	rescue
  		redirect_to action: "profile",controller: "main"
  	end
  end
  def submit
  	if params[:post]==""
  		redirect_to action: "show", id: $global_id, error_post: "empty post"
  	else
      new_post  = PagesPost.new
      new_post.content = params[:post]
      new_post.likes = 0
      new_post.page_id = $global_id
      new_post.user_id = cookies[:user_id]
      new_post.save
  		redirect_to action: "show", id: $global_id
  	end
  end
end
