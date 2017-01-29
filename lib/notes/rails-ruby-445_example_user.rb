################################################################################
# Classes: #####################################################################
################################################################################

puts "# Text: ##################################################################"

require './example_user'

p example = User.new

p example.name

example.name = 'Example User'
example.email = 'user@example.com'
puts example.name
puts example.email
puts example.formatted_email

user = User.new( { name: "Michael Hartl", email: "mhartl@example.com" } )
user = User.new( name: "Michael Hartl", email: "mhartl@example.com" )
puts user.formatted_email



puts "# Exercises: #############################################################"

################################################################################
#1. In the example User class, change from name to separate first and last name
#   attributes, and then add a method called full_name that returns the first 
#   and last names separated by a space. Use it to replace the use of name in 
#   the formatted email method.

#class User
#  attr_accessor :name, :email
#
#  def initialize(attributes = {})
#    @name  = attributes[:name]
#    @email = attributes[:email]
#  end
#
#  def formatted_email
#    "#{@name} <#{@email}>"
#  end
#end

class FancyUser
  attr_accessor :first, :last, :email

  def initialize(attributes = {})
    @first = attributes[:first]
    @last  = attributes[:last]
    @email = attributes[:email]
  end

  def full_name
    "#{@first} #{@last}"    
  end
  def formatted_email
    "#{full_name} <#{@email}>"
  end
end

user = FancyUser.new first: 'Martin', last: 'Fencl', email: 'martin.fencl@gmail.com'
puts user.full_name
puts user.formatted_email

################################################################################
#2. Add a method called alphabetical_name that returns the last name and first
#   name separated by comma-space.

class FancyUser
  def alphabetical_name
    "#{@last}, #{@first}"
  end
end

puts user.alphabetical_name

################################################################################
#3. Verify that full_name.split is the same as 
#   alphabetical_name.split(’, ’).reverse.

puts user.full_name.split == user.alphabetical_name.split( ', ' ).reverse



################################################################################

