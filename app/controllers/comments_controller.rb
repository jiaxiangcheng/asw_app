class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]


  def index
    @comments = Comment.all
  end

  def my_comments
    if current_user
      @comments = Comment.where(user_id: current_user.id)
    else
      @comments = Comment.all
    end
    render "index"
  end

  # comments I voted on
  def voted_comments
    if current_user
      @comments = Comment.all.select {|c| current_user.voted_for? c }
    else
      @comments = Comment.all
    end
    render "index"
  end

  # POST /comments
  # POST /comments.json
  def create
    if user_is_logged?
      @submission = Submission.find(params[:submission_id])
      @comment = @submission.comments.new(comment_params)
      @comment.user = current_user
      @submission.replies << @comment

      respond_to do |format|
        if @comment.save
          format.html { redirect_to @submission, notice: 'Comment was successfully created.' }
          format.json { render json: @comment, status: :created, location: @comment }
        else
          format.html { render action: "new" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def createreply
    if current_user
      @comment = Comment.find(params[:id])
      reply = @comment.replies.new(reply_params)
      reply.user = current_user
      reply.submission = @comment.submission
      reply.parent = @comment
      respond_to do |format|
        if reply.save
          format.html { redirect_to reply.submission, notice: 'Reply was successfully created.' }
          format.json { render json: reply, status: :created, location: reply }
        else
          format.html { render action: "new" }
          format.json { render json: reply.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def showreply
    if current_user
      @comment = Comment.find(params[:id])
      @submission = @comment.submission
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to params.key?(:goto) ? params[:goto] : root_path, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def upvote
    if current_user
      @comment = Comment.find(params[:id])
      @comment.upvote_by current_user
      redirect_to params.key?(:goto) ? params[:goto] : root_path
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def downvote
    if current_user
      @comment = Comment.find(params[:id])
      @comment.downvote_by current_user
      redirect_to params.key?(:goto) ? params[:goto] : root_path
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def unvote
    if current_user
      @comment = Comment.find(params[:id])
      @comment.unvote_by current_user
      redirect_to params.key?(:goto) ? params[:goto] : root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:submission_id, :body, :user_id)
    end

    def reply_params
      params.require(:comment).permit(:id, :body)
    end
end
