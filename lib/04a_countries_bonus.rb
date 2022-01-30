# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT 
    a.name
  FROM 
    countries AS a 
  WHERE 
    a.gdp > ALL (
      SELECT b.gdp
      FROM countries AS b 
      WHERE b.continent = 'Europe'
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT 
    a.continent,
    a.name AS country,
    a.area
  FROM
    countries AS a
  WHERE
    a.area >= ALL (
      SELECT b.area FROM countries AS b
      WHERE a.continent = b.continent
      AND (area > 0)
    )
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
    a.name AS country,a.continent
  FROM 
    countries AS a
  WHERE a.population > ALL (
    SELECT b.population*3
    FROM countries AS b
    WHERE a.continent = b.continent
      AND a.name <=> b.name
  )
  SQL
end
