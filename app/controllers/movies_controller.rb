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
    p "@title_hilite.nil? >> " + @title_hilite.nil?.to_s
    if @title_hilite.nil? == true
      p "@title_hilite is NIL"
      @title_hilite = {}
    end
  end

  def  release_date_hilite
    p " @release_date_hilite.nil? >> :" +  @release_date_hilite.nil?.to_s
    if @release_date_hilite.nil? == true
      p "@release_date_hilite is NIL"
      @release_date_hilite= {}
    end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index


    #save the ratings
    selected_ratings = params[:ratings]
    iscommit = params.key? "commit"

    if ! selected_ratings.nil?
      @all_ratings_status = selected_ratings
    elsif iscommit
      @all_ratings_status.clear
      else
      @all_ratings_status = {'G' => "1" , 'PG' => "1",'PG-13'=> "1" , 'R' => "1"}

    end

    p "-----------------"

    #solrt colum in the variable 'sort'
    column  = params[:sort]

    p "sorting column : " + sorting_column.to_s

    if !column.nil? && !column.empty?
      p "Column is NOT nil"
      @sorting_column = column
      @movies = Movie.where("rating IN (?) ",selected_ratings_for_sorting).order(@sorting_column)

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
    else
      p "column IS NIL"
      @title_hilite = {}
      @release_date_hilite = {}
      @movies = Movie.where("rating IN (?) ", selected_ratings_for_sorting)
    end

    p ">> title hilite -> " + @title_hilite.to_s + " >> " + @title_hilite.nil?.to_s
    p ">> release_date_hilite -> " + @release_date_hilite.to_s + " >> " + @release_date_hilite.nil?.to_s


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
