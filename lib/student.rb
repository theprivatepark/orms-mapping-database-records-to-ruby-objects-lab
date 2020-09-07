require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new()
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all

    sql = " SELECT * 
          FROM STUDENTS"

    DB[:conn].execute(sql).map {|s| Student.new_from_db(s)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = " SELECT * 
          FROM students 
          where name = ?
          LIMIT 1"
  
  query_result = DB[:conn].execute(sql, name)
    # binding.pry
    Student.new_from_db(query_result[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
  
    sql = " SELECT *
          FROM students
          WHERE grade = 9"

    DB[:conn].execute(sql).map {|s| Student.new_from_db(s)}

  end

  def self.students_below_12th_grade
  
    sql = "SELECT *
          FROM students
          WHERE grade < 12"

    DB[:conn].execute(sql).map {|s| Student.new_from_db(s)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = " SELECT *
            FROM students
            WHERE grade = 10
            LIMIT ?"

    DB[:conn].execute(sql, x).map {|s| Student.new_from_db(s)}
  end

  def self.first_student_in_grade_10 
    Student.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT *
          FROM students
          WHERE grade = ?"

          DB[:conn].execute(sql,x).map {|s|Student.new_from_db(s)}
  end

end
