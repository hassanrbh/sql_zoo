# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT 
    movie.title AS movie
  FROM
    movies AS movie
  INNER JOIN castings
    ON movie.id = castings.movie_id
  WHERE castings.actor_id = 6;
  SQL
end
def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    movie.title AS movie
  FROM
    movies AS movie
  INNER JOIN castings
    ON movie.id = castings.movie_id
  WHERE castings.actor_id = 6
  AND castings.ord > 1;
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    movie.title, name AS leading_star
  FROM
    movies AS movie
  INNER JOIN castings
    ON castings.movie_id = movie.id
  INNER JOIN actors
    ON actors.id = castings.actor_id 
  WHERE
    movie.yr = 1962 AND castings.ord = 1;
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    movie.yr,
    COUNT(movie.yr)
  FROM
    movies AS movie
  INNER JOIN actors
    ON actors.id = movie.id
  INNER JOIN castings all_actors on movie.id = all_actors.movie_id
  WHERE
    all_actors.actor_id = (
        SELECT
            actor.id
        FROM
            actors AS actor
        WHERE actor.name = 'John Travolta'
        )
  GROUP BY movie.yr
  HAVING COUNT(movie.yr) >= 2;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    movie.title,
    actor.name
  FROM
    movies AS movie
  INNER JOIN castings casting
    ON casting.movie_id = movie.id
  INNER JOIN actors actor
    ON casting.actor_id = actor.id
  WHERE
    movie.id IN (
        SELECT
            movies.id
        FROM
            movies
        INNER JOIN castings ON movies.id = castings.movie_id
        INNER JOIN actors ON castings.actor_id = actors.id
        WHERE
            actors.name = 'Julie Andrews' AND castings.ord = 1
    );
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    alphabitcs.name
  FROM
  (
      SELECT
        actor.name, COUNT(casting.movie_id) star_count
      FROM
        actors AS actor
      INNER JOIN castings casting
        ON actor.id = casting.actor_id
      WHERE
        casting.ord = 1
      GROUP BY actor.name
  ) AS alphabitcs
  WHERE star_count >= 15
  ORDER BY alphabitcs.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
SELECT
    movie.title, COUNT(*) cast_size
FROM
    movies AS movie
INNER JOIN castings casting ON movie.id = casting.movie_id
WHERE
        movie.yr = 1978
GROUP BY movie.title
ORDER BY cast_size DESC
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SELECT 
    actors.name 
  FROM 
    actors

  SQL
end
