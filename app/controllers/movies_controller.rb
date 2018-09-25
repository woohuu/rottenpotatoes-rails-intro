class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # generate a collection of all rating values
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    # find the ratings that were checked by user or set initial value to include all ratings
    @checked_ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    # checked hash to be used to mark the "checked" attribute of check box
    @checked = {}
    @checked_ratings.each { |x| @checked[x] = true }
    
    if params[:sort]
      @movies = Movie.order(params[:sort]) #sort the table using order method
    else
      @movies = Movie.where(:rating => @checked_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
