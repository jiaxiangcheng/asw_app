class SubmissionsController < ApplicationController
  helper ApplicationHelper
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  # GET /submissions
  # GET /submissions.json
  # GET /submissions/news
  # GET /submissions/news.json
  def index
    if params.key?(:type) && params[:type] == :created_at
      @submissions = Submission.all.order("created_at DESC")
    elsif params.key?(:type) && params[:type] == :points
      @submissions = Submission.all.order("points DESC")
    else
      @submissions = Submission.all.order("points DESC").select { |s| s.url == ""}
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
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    new_url = submission_params[:url]
    # sub. with this url exists (and is not ask)
    if new_url != "" && Submission.exists?(url: new_url)
      existing_submission = Submission.find_by(url: new_url)
      redirect_to item_path(id: existing_submission.id)
    else # create new submission
      @submission = Submission.new(submission_params)
      @submission.points = 0
      @submission.created_at = Time.now()
      @submission.num_comments = 0
      @submission.author = "Donald Duck"

      respond_to do |format|
        if @submission.save
          format.html { redirect_to newest_menu_path, notice: 'News was successfully created.' }
          format.json { render :show, status: :created, location: @submission }
        else
          format.html { render :new }
          format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
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
