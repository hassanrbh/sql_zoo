# == Schema Information
#
# Table name: teachers
#
#  id          :integer      not null, primary key
#  dept_id     :integer
#  name        :string
#  phone       :integer
#  mobile      :string
#
# Table name: depts
#
#  id          :integer      not null, primary key
#  name        :string       not null

require_relative './sqlzoo.rb'

def null_dept
  # List the teachers who have NULL for their department.
  execute(<<-SQL)
  SELECT 
    teacher.name
  FROM  
    teachers AS teacher
  WHERE
    teacher.dept_id IS NULL
  SQL
end

def all_teachers_join
  # Use a type of JOIN that will list all teachers and their department,
  # even if the department in NULL/nil.
  execute(<<-SQL)
  SELECT
    teacher.name , dept.name
  FROM
    teachers AS teacher
  LEFT  JOIN depts dept
    ON teacher.dept_id = dept.id
  SQL
end

def all_depts_join
  # Use a different JOIN so that all departments are listed.
  # NB: you can avoid RIGHT OUTER JOIN (and just use LEFT) by swapping
  # the FROM and JOIN tables.
  execute(<<-SQL)
  SELECT
    teacher.name , dept.name
  FROM
    teachers AS teacher
  RIGHT JOIN depts dept
    ON teacher.dept_id = dept.id
  SQL
end

def teachers_and_mobiles
  # Use COALESCE to print the mobile number. Use the number '07986
  # 444 2266' if no number is given. Show teacher name and mobile
  # #number or '07986 444 2266'
  execute(<<-SQL)
  SELECT
    teacher.name,
    COALESCE(teacher.mobile,'07986 444 2266') mobile
  FROM
    teachers AS teacher
  SQL
end

def teachers_and_depts
  # Use the COALESCE function and a LEFT JOIN to print the teacher name and
  # department name. Use the string 'None' where there is no
  # department.
  execute(<<-SQL)
  SELECT
    teacher.name,
    COALESCE(dept.name, 'None') deptId
FROM
    teachers AS teacher
        LEFT JOIN depts AS dept
                  ON teacher.dept_id = dept.id
  SQL
end

def num_teachers_and_mobiles
  # Use COUNT to show the number of teachers and the number of
  # mobile phones.
  # NB: COUNT only counts non-NULL values.
  execute(<<-SQL)
  SELECT
    COUNT(teacher.name),
    COUNT(teacher.mobile)
  FROM
    teachers AS teacher
  SQL
end

def dept_staff_counts
  # Use COUNT and GROUP BY dept.name to show each department and
  # the number of staff. Structure your JOIN to ensure that the
  # Engineering department is listed.
  execute(<<-SQL)
  SELECT dept.name, COUNT(teacher.id) num_teachers
  FROM teachers AS teacher
  RIGHT JOIN depts dept
  ON teacher.dept_id = dept.id
  GROUP BY dept.name
  SQL
end

def teachers_and_divisions
  # Use CASE to show the name of each teacher followed by 'Sci' if
  # the teacher is in dept 1 or 2 and 'Art' otherwise.
  execute(<<-SQL)
  SELECT
    teacher.name,
    CASE
        WHEN teacher.dept_id IS NULL
            THEN 'Art'
            ELSE 'Sci'
        END teacher_spec
FROM teachers As teacher
  SQL
end

def teachers_and_divisions_two
  # Use CASE to show the name of each teacher followed by 'Sci' if
  # the teacher is in dept 1 or 2, 'Art' if the dept is 3, and
  # 'None' otherwise.
  execute(<<-SQL)
SELECT
    teacher.name,
    CASE
        WHEN teacher.dept_id IN (1,2)
            THEN 'Sci'
        WHEN teacher.dept_id = 3
            THEN 'Art'
        ELSE
            'None'
        END teacher_spec
FROM teachers As teacher
  SQL
end
