class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @articles = current_user.articles.where(archived: false)
    @Articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = current_user.articles.find(params[:id])

    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    if @article.destroy
      puts "Article successfully destroyed."
    end

    redirect_to root_path, notice: 'Article was successfully destroyed.'
  end

  def report
    @article = Article.find(params[:id])
    @article.increment!(:reports_count)
    if @article.reports_count >= 3
      @article.update(archived: true)
      flash[:alert] = 'Article has been archived due to multiple reports.'
    else
      flash[:notice] = 'Article has been reported.'
    end
    redirect_to @article
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status, :image)
  end
end
