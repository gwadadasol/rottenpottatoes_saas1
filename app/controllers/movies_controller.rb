class MoviesController < ApplicationController

  #def initialize
  #  @release_date_hilite = Hash.new
  #  @title_hilite = Hash.new
  #  super
  #end

  def sorting_column
    @sorting_column
  end

  def hilite_column(column_name)
    #if column_name.to_s.eql? @sorting_column
    # return "test"
    #['class' => 'hilite']
    #else
    #  {}
    #end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # default value is empty
    if @release_date_hilite.nil? ; @release_date_hilite= Hash.new;end
    if @title_hilite.nil?; @title_hilite = Hash.new; end

    #solrt colum in the variable 'sort'
    column  = params[:sort]

    if !column.nil?
      @movies = Movie.order(column)

      if column.eql? "title"
        # sorting the title column
        #highlight the title column header
        @title_hilite = Hash['class' => 'hilite']

        # normal release date column header
        @release_date_hilite = Hash[]
      else
        #sort by release date column

        #highlight release date column header
        @release_date_hilite = Hash['class' => 'hilite']

        # normal title column header
        @title_hilite = Hash[]
      end
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
