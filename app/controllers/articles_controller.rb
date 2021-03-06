class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  include InitiateSearch
  # GET /articles
  # GET /articles.json
  def index
    add_breadcrumb "Articles", :articles_path
    @articles = Article.search params.try(:[], :search).try(:[], :query), :sql => {:include => :user}, page: params[:page]
    respond_to do |format|
      format.js { render :search}
      format.html{ render :index}
    end

  end

  def generate
    EventHandleWorker.perform_in(5.minutes, 'bob', 5)
    redirect_to articles_path
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    add_breadcrumb @article.id, article_path(@article)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @video = Video.new
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      add_breadcrumb "Articles", :articles_path
      @article = Article.includes(:videos).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body, :user_id)
    end
end
