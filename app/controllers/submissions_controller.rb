class SubmissionsController < ApplicationController
  helper ApplicationHelper
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :unvote]

  # GET /submissions
  # GET /submissions.json
  # GET /submissions/news
  # GET /submissions/news.json
  def index
    @users = User.all
    if params.key?(:type) && params[:type] == :created_at
      @submissions = Submission.all.order("created_at DESC")
    elsif params.key?(:type) && params[:type] == :points
      @submissions = Submission.all.order(cached_votes_score: :desc)
    elsif params.key?(:type) && params[:type] == :ask
      @submissions = Submission.all.order(cached_votes_score: :desc).select { |s| s.url == ""}
    elsif params.key?(:type) && params[:type] == :my_submissions
      if user_is_logged?
        @submissions = Submission.where(user_id: current_user.id)
      else # not authorized
        respond_to do |format|
          format.html { redirect_to '/auth/google_oauth2' }
          format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
        end 
      end
    else
      @submissions = Submission.all.order(cached_votes_score: :desc)
    end
  end

  # the submissions are mine, the votes don't have to be
  def voted_submissions
    if user_is_logged?
      @submissions = Submission.all.select {|s| current_user.voted_for? s }
    else
      respond_to do |format|
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end 
    end
  end

  # GET /submissions/ask
  # GET /submissions/ask.json
  def ask
    @submissions = Submission.all.order("created_at DESC")
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])
  end

  # GET /submissions/new
  def new
    if user_is_logged?
      @submission = current_user.submissions.build
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    if user_is_logged?
      new_url = submission_params[:url]
      # sub. with this url exists (and is not ask)
      if new_url != "" && Submission.exists?(url: new_url)
        existing_submission = Submission.find_by(url: new_url)
        redirect_to submission_path(id: existing_submission.id)
      else # create new submission
        @submission = current_user.submissions.create(submission_params)
        @submission.created_at = Time.now()
        @submission.num_comments = 0

        respond_to do |format|
          if @submission.save
            format.html { redirect_to newest_menu_path, notice: 'News was successfully created.' }
            format.json { render :show, status: :created, location: @submission }
          else
            format.html { render :new }
            format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
          end
        end
      end
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    if user_is_logged?
      respond_to do |format|
        if @submission.update(submission_params)
          format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
          format.json { render :show, status: :ok, location: @submission }
        else
          format.html { render :edit }
          format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    if user_is_logged?
      @submission.destroy
      respond_to do |format|
        format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end
    end
  end

  def upvote
    if user_is_logged?
      if @submission.user != current_user
        @submission.upvote_by current_user
        redirect_to params.key?(:goto) ? params[:goto] : root_path
        # respond_to do |format|
        #   format.json { render :show, status: :ok, location: @submission }
        # end
      end
    else
      respond_to do |format|
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end 
    end
  end

  def downvote
    if user_is_logged?
      if @submission.user != current_user
        @submission.downvote_by current_user
        redirect_to params.key?(:goto) ? params[:goto] : root_path
        # respond_to do |format|
        #   format.json { render :show, status: :ok, location: @submission }
        # end
      end
    else
      respond_to do |format|
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end 
    end
  end

  def unvote
    if user_is_logged?
      if @submission.user != current_user
        @submission.unvote_by current_user
        redirect_to params.key?(:goto) ? params[:goto] : root_path
      end
    else
      respond_to do |format|
        format.json { render json: {error: "provide API key in Token header field"}, status: :unauthorized }
      end 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.permit(:title, :url, :text)
    end
end
