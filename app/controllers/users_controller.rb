class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      if User.exists?(params[:id])
        @user = User.find(params[:id])
        format.html { render :show }
        format.json { render json: @user, status: :ok }
      else
        format.json { render json: {user: @user.errors }, status: :bad_request }
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !current_user || (current_user && current_user.id != @user.id)
      redirect_to :controller => 'users', :action => 'show'
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if user_is_logged? && @user != nil
        if current_user == @user 
          if @user.update(user_params)
            format.html { redirect_to @user, notice: 'User was successfully updated.' }
            format.json { render json: @user, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to '/auth/google_oauth2' }
          format.json { render json: {error: "provide API key in Token header field and make sure it matches the user who created the user"}, status: :unauthorized }
        end
      elsif @user == nil
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "Does not exist this user"}, status: :not_found }
      else
        format.html { redirect_to '/auth/google_oauth2' }
        format.json { render json: {error: "provide API key in Token header field and make sure it matches the user who created the user"}, status: :unauthorized }
      end
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if User.exists?(params[:id])
        @user = User.find(params[:id])
      else
        @user = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :user_id, :about)
    end
end
