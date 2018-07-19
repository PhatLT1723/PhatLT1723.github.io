class QuestionsController < ApplicationController
  before_action :baseUrl
  before_action :set_group, only: [:show, :edit, :update_mod, :new, :create_mod, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    url = @httpIp + '/pet.com/api/question/getAllQuestions'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    # @questions = JSON.parse(response, object_class: OpenStruct)
    @questions = Kaminari.paginate_array(JSON.parse(response, object_class: OpenStruct)).page(params[:page]).per(7)
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create_mod
    if params[:title] != nil && params[:content] != nil && params[:subId] != nil && params[:userId] != nil && params[:groupId] != nil
      @question.title = params[:title]
      @question.content = params[:content]
      @question.subId = params[:subId].to_i
      @question.userId = params[:userId].to_i
      @question.groupId = params[:groupId].to_i

      question_json = @question.to_h.to_json

      url = @httpIp+'/pet.com/api/question/createQuestion'
      uri = URI(url)
      res = Net::HTTP.post(uri, question_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully created"
      redirect_to questions_path

    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update_mod
    if params[:title] != nil && params[:content] != nil
      @question.title = params[:title]
      @question.content = params[:content]

      question_json = @question.to_h.to_json

      url = @httpIp+'/pet.com/api/question/updateQuestion'
      uri = URI(url)
      res = Net::HTTP.post(uri, question_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully updated"
      redirect_to questions_path
  end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.active = !@question.active

      questions_json = @question.to_h.to_json

      url = @httpIp+'/pet.com/api/question/updateQuestion'
      uri = URI(url)
      res = Net::HTTP.post(uri, questions_json, "Content-Type" => "application/json")
      puts res.body
      flash[:notice] = "successfully deleted"
      redirect_to questions_path
  end

  private
    def set_group
      url = @httpIp + '/pet.com/api/question/getAllQuestions'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @questions = JSON.parse(response, object_class: OpenStruct)

      if params[:id] != nil
        @question = @questions.detect{|q| q.quesId == params[:id].to_i }
      else
        @question = @questions.last
        @question.quesId = @question.quesId + 1;
        @question.title = ""
        @question.userId = nil
        @question.groupId = nil
        @question.subId = nil
        @question.content = ""
        @question.createdDate = nil
        @question.updatedDate = nil
        @question.active = true
        @question.approvedAnswer = false
        @question.totalAnswers = 0
        @question.closedDate = nil
      end
    end
end
