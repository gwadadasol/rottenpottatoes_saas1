class Movie < ActiveRecord::Base
  def all_ratings
    return Array.new ['G','PG','PG-13','R']
  end
end
