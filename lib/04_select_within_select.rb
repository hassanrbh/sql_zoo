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

# A note on subqueries: we can refer to values in the outer SELECT within the
# inner SELECT. We can name the tables so that we can tell the difference
# between the inner and outer versions.

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
  SELECT
    name
  FROM 
    countries
  WHERE
    population > (
      SELECT population FROM countries WHERE name LIKE 'Russia'
    );
  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
  SELECT
    name
  FROM 
    countries
  WHERE 
    continent LIKE 'Europe' AND (gdp/population) > (
      SELECT
        (gdp/population) AS per_capita_gdp_united_kingdom
      FROM
        countries
      WHERE 
        name LIKE 'United Kingdom'
    ) 
  SQL
end

def neighbors_of_certain_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
  SELECT
    name,continent
  FROM
    countries
  WHERE
    continent IN
    (
      select continent from countries where name IN ('Belize','Belgium')
    );
  SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland ? Show the name and the population.
  execute(<<-SQL)
  SELECT 
    basic_countries.name AS country, 
    basic_countries.population 
  FROM 
    countries AS basic_countries
  WHERE 
    basic_countries.population > (
      SELECT 
        medium_countries.population
      FROM 
        countries AS medium_countries 
      WHERE 
        medium_countries.name = 'Canada' 
        AND basic_countries.population  < (
          SELECT 
            advance_countries.population 
          FROM 
            countries AS advance_countries
          WHERE 
            advance_countries.name = 'Poland'
        )
    )
  SQL
end

def sparse_continents
  # Find every country that belongs to a continent where each country's
  # population is less than 25,000,000. Show name, continent and
  # population.
  # Hint: Sometimes rewording the problem can help you see the solution.
  execute(<<-SQL)
  SELECT 
    first_country.name AS country,
    first_country.continent,
    first_country.population
  FROM 
    countries AS first_country
  WHERE 
    25000000 > ALL (
      SELECT second_country.population
      FROM countries AS second_country
      WHERE first_country.continent = second_country.continent
      AND (second_country.population > 0)
    );
  SQL
end
