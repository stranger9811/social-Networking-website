class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    if cookies[:user_id]!="4"
      redirect_to action: "profile",controller: "main"
    end
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def submit
    if params[:post]==""
      redirect_to action: "show", id: $global_id, error_post: "empty post"
    else
      new_post  = GroupPost.new
      new_post.content = params[:post]
      new_post.group_id = $global_id
      new_post.user_id = cookies[:user_id]
      new_post.save
      redirect_to action: "show", id: $global_id
    end
  end
  def comment
    if params[:comment]!=""
      new_comment = GroupComment.new
      new_comment.added_by = cookies[:user_id]
      new_comment.comment = params[:comment]
      new_comment.post_id = params[:post_id]
      new_comment.save
    end
    redirect_to action: "show",id: $global_id
  end
  def show
    begin
      $global_id = params[:id]
     
      @group_posts = GroupPost.find_by_sql("select * from group_posts where group_id="+params[:id])
    rescue
      redirect_to action: "profile",controller: "main"
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def add_member
    @g = Group.find(params[:id])
    if @g.privacy == "public" 
      @n = GroupMember.new
      @n.group_id = params[:id]
      @n.user_id = cookies[:user_id]
      @n.save
      @g.group_members << @n
    else
      @n = GroupRequest.new
      @n.group_id = params[:id]
      @n.user_id = cookies[:user_id]
      @n.save
      @g.group_requests << @n
    end
    redirect_to action: "show", id: params[:id]
  end
  def leave_member
    GroupMember.where(:user_id => cookies[:user_id],:group_id => params[:id])[0].destroy
    redirect_to action: "show", id: params[:id]
  end
  def create
    @group = Group.new(group_params)
    @group.timeline_pic = params[:group][:timeline_pic]
    @group.admin_id = cookies[:user_id]
    
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
        @g = GroupMember.new
        @g.group_id = @group.id
        @g.user_id = cookies[:user_id]
        @g.save
        @group.group_members << @g
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
def add_request
  @n = GroupMember.new
  @n.user_id = params[:new_user_id]
  @n.group_id = params[:id]
  @n.save
  @g = Group.find(params[:id])
  @g.group_members <<  @n
  GroupRequest.where(:user_id => params[:new_user_id],:group_id => params[:id])[0].destroy
  redirect_to action: "show", id: params[:id]
end
def delete_request
  GroupRequest.where(:user_id => params[:new_user_id],:group_id => params[:id])[0].destroy
  redirect_to action: "show", id: params[:id]
end
  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description, :privacy, :admin_id,:timeline_pic)
    end
end
