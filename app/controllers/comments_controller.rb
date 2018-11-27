class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :unvote, :createreply]


  def index
    if params.key?(:filter) && params[:filter] == "voted_by_me"
      if user_is_logged?
        @comments = Comment.all.select {|c| current_user.voted_for? c }
      else
        respond_to do |format|
          format.html { redirect_to '/auth/google_oauth2' }
          format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
        end
      end
    elsif params.key?(:type) && params[:type] == :my_comments
      if user_is_logged?
        @comments = Comment.where(user_id: current_user.id)
      else # not authorized
        respond_to do |format|
          format.html { redirect_to '/auth/google_oauth2' }
          format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
        end
      end
    elsif params.key?(:created_by)
      if User.find(params[:created_by])
        @comments = Comment.where(user_id: params[:created_by])
      else
        respond_to do |format|
          format.json { render json: {created_by: "given userId doesn't match any user"}, status: :not_found }
        end
      end
    elsif request.fullpath.split("/")[1] == "submissions"
      @submission = Submission.find(params[:submission_id])
      @comments = @submission.replies
    else
       @comments = Comment.all
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    if Comment.exists?(params[:id])
      @comment = Comment.find(params[:id])
    else
      respond_to do |format|
        format.json { render json: {comment_id: "no comment found for this id"}, status: :not_found }
      end
    end
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
    respond_to do |format|
      if user_is_logged?
        if Submission.exists?(params[:submission_id])
          @submission = Submission.find(params[:submission_id])
          @comment = @submission.comments.new(comment_params)
          @comment.user = current_user
          @submission.replies << @comment
          if @comment.save
            format.html { redirect_to @submission, notice: 'Comment was successfully created.' }
            format.json { render json: @comment, status: :created, location: @comment }
          else
            format.html { render action: "new" }
            format.json { render json: {comment: @comment.errors }, status: :bad_request }
          end
        else # trying to comment not existing submission
          # format.html -> show default rails error page
            format.json { render json: {submission_id: "no submission found for this id"}, status: :not_found }
        end
      else # not authorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end
    end
  end

  def createreply
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged?
        reply = @comment.replies.new(reply_params)
        reply.user = current_user
        reply.submission = @comment.submission
        reply.parent = @comment
        if reply.save
          format.html { redirect_to reply.submission, notice: 'Reply was successfully created.' }
          format.json { render json: reply, status: :created, location: reply }
        else
          format.html { render action: "new" }
          format.json { render json: {reply: reply.errors }, status: :bad_request }
        end
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged? && @comment.user == current_user
        if @comment.update(comment_params)
          format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit }
          format.json { render json: @comment.errors, status: :bad_request }
        end
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it matches the user who created the comment"}, status: :unauthorized }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged? && @comment.user == current_user
        @comment.destroy
        format.html { redirect_to params.key?(:goto) ? params[:goto] : root_path, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it's from the user who created the comment"}, status: :unauthorized }
      end
    end
  end

  def upvote
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged? && @comment.user != current_user
        @comment.upvote_by current_user
        format.html { redirect_to params.key?(:goto) ? params[:goto] : root_path }
        format.json { head :no_content }
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it's from a different user than the one who created the comment"}, status: :unauthorized }
      end
    end
  end

  def downvote
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged? && @comment.user != current_user
        @comment.downvote_by current_user
        format.html { redirect_to params.key?(:goto) ? params[:goto] : root_path }
        format.json { head :no_content }
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it's from a different user than the one who created the comment"}, status: :unauthorized }
      end
    end
  end

  def unvote
    respond_to do |format|
      if @comment == nil # no comment exists for id in path
        format.json { render json: {id: "no comment found for this id"}, status: :not_found }
      elsif user_is_logged? && @comment.user != current_user
        @comment.unvote_by current_user
        format.html { redirect_to params.key?(:goto) ? params[:goto] : root_path }
        format.json { head :no_content }
      else # unauthorized
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it's from a different user than the one who created the comment"}, status: :unauthorized }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      if Comment.exists?(params[:id])
        @comment = Comment.find(params[:id])
      else
        @comment = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body)
    end

    def reply_params
      params.require(:comment).permit(:id, :body)
    end
end
