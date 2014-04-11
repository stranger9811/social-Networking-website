class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    if cookies[:user_id]!="4"
      redirect_to action: "profile",controller: "main"
    end
    @pages = Page.all

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
  		new_page.like = 0 
  		new_page.save
  		redirect_to action: "show", id: new_page.id
  	end
    redirect_to action: "show", id: new_page.id
  end
  def pageLike
    if params[:is_liked]=="unlike"
      PagesLike.find_by_sql("select * from pages_likes where user_id="+cookies[:user_id]+" and page_id="+params[:id])[0].destroy
      current_page = Page.find(params[:id])
      current_page.like=current_page.like-1
      current_page.save
    else
      printf "current controller: page action: pageLike"
      new_like = PagesLike.new
      new_like.user_id = cookies[:user_id]
      new_like.page_id = params[:id]
      new_like.save
      current_page = Page.find(params[:id])
      print current_page
      current_page.like=current_page.like+1
      current_page.save
    end
    redirect_to action: "show", id: $global_id
  end

  # GET /pages/1
  # GET /pages/1.json
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

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)
    @page.profile_pic = params[:page][:profile_pic]
    @page.timeline_pic = params[:page][:timeline_pic]
    @page.like = 0
    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :description, :like, :privacy, :admin_id,:profile_pic,:timeline_pic)
    end
end
