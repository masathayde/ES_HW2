# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
    @checked_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
    @style = "hilite"
    sort_by = params[:sort_by] || session[:sort_by]
    session[:sort_by] = params[:sort_by] unless params[:sort_by] == nil
    ratings = params[:ratings]
    if params[:ratings] != nil
      chosen_ratings = {rating: params[:ratings].keys}
      @checked_ratings = []
      params[:ratings].keys.each do |rating|
        @checked_ratings << rating
      end
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != nil
      chosen_ratings = {rating: session[:ratings].keys}
      @checked_ratings = []
      session[:ratings].keys.each do |rating|
        @checked_ratings << rating
      end
    end
    @movies = Movie.order(sort_by).all.where(chosen_ratings)
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end

end