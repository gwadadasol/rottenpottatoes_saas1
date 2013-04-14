class MoviesController < ApplicationController


  helper_method :all_ratings_status, :all_ratings, :sorting_column, :title_hilite, :release_date_hilite

  def initialize
    @all_ratings #Movie.all_ratings
    # @all_ratings_status = {'G' => true, 'PG' => true ,'PG-13'=> true , 'R' => true}
    #selected_ratings = params[:ratings]
    #p selected_ratings
    super
  end

  def all_ratings_status
    if @all_ratings_status.nil?
      @all_ratings_status = {'G' => "1" , 'PG' => "1",'PG-13'=> "1" , 'R' => "1"}
    end
    @all_ratings_status
  end

  def selected_ratings_for_sorting
    @all_ratings_status.keys
  end


  def all_ratings
    if @all_ratings.nil?
      @all_ratings= ['G','PG','PG-13','R']
    end
    @all_ratings
  end

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

  def title_hilite
    if @title_hilite.nil? == true
      @title_hilite = {}
    end
  end

  def  release_date_hilite
    if @release_date_hilite.nil? == true
      @release_date_hilite= {}
    end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    # -----------------
    # RATING MANAGEMENT
    # -----------------

    #save the ratings
    if (params.key?("ratings") && ( params[:ratings].nil? == false))
      selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session.key? "ratings"
      selected_ratings = session[:ratings]
    end

    p ">> selected_rating :" + selected_ratings.to_s


    iscommit = params.key? "ratings_submit"

    # get the name of the column to sort
    # column  = params[:sort]
    issorted = false
    if params.key? "sort"
      column  = params[:sort]
      issorted = true
    elsif session.key? "sort"
      column = session[:sort]
      issorted = true
    end

    #p ">> selected_ratings: " + selected_ratings.to_s
    if ! selected_ratings.nil?
      # save the rating
      @all_ratings_status = selected_ratings

      # the rating is empty
      # >> NOT POSSIBLE ANY MORE: in case the user unselects all ratings
      # one uses the values saved in the session
    #elsif iscommit
      # because the user unchecked all the rating
      # all_ratings_status.clear

    # elsif issorted
      # because the user uncked all the rating AND sorted one column
      # @all_ratings_status = {}

    # else
      # because it is the first connection
      # @all_ratings_status = {'G' => "1" , 'PG' => "1",'PG-13'=> "1" , 'R' => "1"}

    end

    # ---------------
    # SORT MANAGEMENT
    # ---------------

    # Column selected
    if !column.nil? && !column.empty?
      @sorting_column = column
      @movies = Movie.where("rating IN (?) ",selected_ratings_for_sorting).order(@sorting_column)
      # set the hightlighting
      if column.eql? "title"
        # sorting the title column
        #highlight the title column header
        @title_hilite = Hash['class' => 'hilite']

        # normal release date column header
        @release_date_hilite = {}
      else
        #sort by release date column

        #highlight release date column header
        @release_date_hilite = Hash['class' => 'hilite']

        # normal title column header
        @title_hilite = {}
      end

      #save the column in the session
      session[:sort] = @sorting_column
    else
      # unset the hightling
      @title_hilite = {}
      @release_date_hilite = {}

      #run the query
      @movies = Movie.where("rating IN (?) ", selected_ratings_for_sorting)
    end

    #save the data in the session
    #p ">> @all_ratings_statu: " + @all_ratings_status.to_s
    session[:ratings] = @all_ratings_status

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path({:ratings => session[:ratings], :sort => session[:sort]})
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie, {:ratings => session[:ratings], :sort => session[:sort]})
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path({:ratings => session[:ratings], :sort => session[:sort]})
  end

end
