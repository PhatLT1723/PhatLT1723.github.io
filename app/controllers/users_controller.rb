class UsersController < ApplicationController
  before_action :baseUrl
  before_action :set_user, only: [:show, :edit, :update_mod, :destroy, :new, :create_mod]


  # GET /users
  # GET /users.json
  def index
    url = @httpIp + '/pet.com/api/user/getAllUsers'
    uri = URI(url)
    response = Net::HTTP.get(uri)

    # @users = JSON.parse(response, object_class: OpenStruct)
    @users = Kaminari.paginate_array(JSON.parse(response, object_class: OpenStruct)).page(params[:page]).per(7)



  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new


  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create_mod
    if params[:roleId] != nil && params[:displayName] != nil && params[:totalPoints] != nil&& params[:username] != nil && params[:password] != nil && params[:email] != nil
      @user.roleId = params[:roleId].to_i
      @user.displayName = params[:displayName]
      @user.username = params[:username]
      @user.password = params[:password]
      @user.email = params[:email]
      @user.totalPoints = params[:totalPoints].to_f

      user_json = @user.to_h.to_json

      url = @httpIp+'/pet.com/api/user/createUser'
      uri = URI(url)
      res = Net::HTTP.post(uri, user_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully created"
      redirect_to root_path

    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update_mod
    if params[:roleId] != nil && params[:displayName] != nil && params[:totalPoints] != nil
      @user.roleId = params[:roleId].to_i
      @user.displayName = params[:displayName]
      @user.totalPoints = params[:totalPoints].to_f

      user_json = @user.to_h.to_json

      url = @httpIp+'/pet.com/api/user/updateUser'
      uri = URI(url)
      res = Net::HTTP.post(uri, user_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully updated"
      redirect_to users_path

    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      url = @httpIp + '/pet.com/api/user/getAllUsers'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @users = JSON.parse(response, object_class: OpenStruct)

      if params[:id] != nil
        @user = @users.detect{|u| u.userId == params[:id].to_i }
      else
        @user = @users.last
        @user.userId = @user.userId + 1;
        @user.username = ""
        @user.password = ""
        @user.displayName = ""
        @user.email = ""
        @user.profileUserUrl = nil
        @user.roleId = 2
        @user.TotalPoints = 0.0
      end
    end


    # # Never trust parameters from the scary internet, only allow the white list through.
    # def user_params
    #   params.require(:user).permit(:roleId, :displayName, :totalPoints)
    # end
end
