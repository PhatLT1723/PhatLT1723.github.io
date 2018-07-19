class GroupsController < ApplicationController
  before_action :baseUrl
  before_action :set_group, only: [:show, :edit, :update_mod, :new, :create_mod, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    url = @httpIp + '/pet.com/api/group/getAllGroups'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    # @groups = JSON.parse(response, object_class: OpenStruct)
    @groups = Kaminari.paginate_array(JSON.parse(response, object_class: OpenStruct)).page(params[:page]).per(7)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create_mod
    if params[:groupName] != nil && params[:password] != nil && params[:subId] != nil && params[:userId] != nil
      @group.groupName = params[:groupName]
      @group.password = params[:password]
      @group.subId = params[:subId].to_i
      @group.userId = params[:userId].to_i

      group_json = @group.to_h.to_json

      url = @httpIp+'/pet.com/api/group/createGroup'
      uri = URI(url)
      res = Net::HTTP.post(uri, group_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully created"
      redirect_to groups_path

    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update_mod
    if params[:groupName] != nil && params[:subId] != nil && params[:password] != nil
      @group.subId = params[:subId] == "" ? nil : params[:subId].to_i
      @group.groupName = params[:groupName]
      @group.password = params[:password] == "" ? nil : params[:password]

      group_json = @group.to_h.to_json

      url = @httpIp+'/pet.com/api/group/updateGroup'
      uri = URI(url)
      res = Net::HTTP.post(uri, group_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully updated"
      redirect_to groups_path
  end
end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
      @group.active = !@group.active

      group_json = @group.to_h.to_json

      url = @httpIp+'/pet.com/api/group/updateGroup'
      uri = URI(url)
      res = Net::HTTP.post(uri, group_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully deleted"
      redirect_to groups_path


  end

  private

    def set_group
      url = @httpIp + '/pet.com/api/group/getAllGroups'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @groups = JSON.parse(response, object_class: OpenStruct)

      if params[:id] != nil
        @group = @groups.detect{|g| g.groupId == params[:id].to_i }
      else
        @group = @groups.last
        @group.groupId = @group.groupId + 1;
        @group.groupName = ""
        @group.subId = nil
        @group.userId = nil
        @group.password = nil
        @group.createdDate = nil
        @group.updatedDate = nil
        @group.active = true
        @group.totalQuestions = 0
        @group.closedDate = nil
      end
    end
end
