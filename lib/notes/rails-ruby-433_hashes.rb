################################################################################
# Hashes and symbols: ##########################################################
################################################################################
#1. Define a hash with the keys ’one’, ’two’, and ’three’, and the values ’uno’, 
#   ’dos’, and ’tres’. Iterate over the hash, and for each key/value pair print 
#   out "’#{key}’ in Spanish is ’#{value}’".

eng_span = { 'one' => 'uno', 'two' => 'dos', 'three' => 'tres' }
eng_span.each do |k, v|
  puts "#{k} in Spanish is #{v}."
end

################################################################################
#2. Create three hashes called person1, person2, and person3, with first and 
#   last names under the keys :first and :last. Then create a params hash so 
#   that params[:father] is person1, params[:mother] is person2, and 
#   params[:child] is person3. Verify that, for example, params[:father][:first] 
#   has the right value.

person1 = { first: 'Albert', last: 'Nordness' }
person2 = { first: 'Doris', Last: 'Nordness' }
person3 = { first: 'Annie', last: 'Hammond' }
params = { father: person1, mother: person2, child: person3 }

puts params[:father][:first]

################################################################################
#3. Define a hash with symbol keys corresponding to name, email, and 
#   a “password digest”, and values equal to your name, your email address, and 
#   a random string of 16 lower-case letters.

user_credentials = { name: 'Martin Fencl', 
  email: 'martin.fencl@gmail.com', 
  'password digest': ('a'..'z').to_a.shuffle[0..15].join }

puts user_credentials
puts user_credentials[:'password digest']

################################################################################
#4. Find an online version of the Ruby API and read about the Hash method merge. 
#   What is the value of the following expression?
#
#   { "a" => 100, "b" => 200 }.merge({ "b" => 300 })

#   > { "a" => 100, "b" => 200, "b" => 300 }      #<= nope, ERROR; read specs!

merged_hash = { "a" => 100, "b" => 200 }.merge({ "b" => 300 })
puts merged_hash
merged_hash_2 = { "a" => 100, "b" => 200 }.merge({ "b" => 300, "c" => 400 })
puts merged_hash_2
################################################################################



################################################################################
puts "Extra notes: ############################################################"
# Speaking of Hashes, 
# ... keep in mind the difference from Arrays when instantiating:

p 'Arrays: #######################'
a = Array.new
p a
p a[3]
a1 = Array.new( [0, 2, 1] )
p a1
p a1[3]
# ... but:
p 'Hashes: #######################'
h = Hash.new
p h
p h[:foo]
h1 = Hash.new( 0 ) #<= sets default value for any, even non-existant key
p h1
p h1[:foo]

