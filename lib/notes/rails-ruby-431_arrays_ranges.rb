################################################################################
# Arrays and ranges: ###########################################################
################################################################################

puts "# Text: ##################################################################"

a = [42, 8, 17]
puts a.first
# puts a.second     #<= only in Rails
puts a.last
puts a.last == a[-1]
puts a.empty?
puts a.include?( 42 )
p a.sort
p a.reverse
p a.shuffle
p a
p a.push( 6 )
p a << 7
p a << 'foo' << 'bar'
p a.join
p a.join( ', ' )

p 0..9
#p 0..9.to_a      #<= oops, call :to_a on 9
p (0..9).to_a
p a = %w( foo bar baz quux )      #<= user %w to make a string array

# Ranges are useful for pulling out array elements:
p a[0..2]         #<= pull out a section of an array

# A particularly useful trick is to use the index -1 at the end of the range 
#   to select every element from the starting point to the end of the array 
#   without explicitly having to use the array’s length:
p = (0..9).to_a
p a[2..a.length-1]
p a[2..-1]

# Ranges also work with characters:
p ('a'..'z')


# By the way, we’re now in a position to understand the line of Ruby I threw 
# into Section 1.5.4 to generate random subdomains:

puts [ ('a'..'z').to_a.shuffle[0..7].join, 'herokuapp.com' ].join( '.' )


puts "# Exercises: #############################################################"

################################################################################
#1. Assign a to be to the result of splitting the string "A man, a plan, 
#   a canal, Panama" on comma-space.

a = "A man, a plan, a canal, Panama".split( ', ' )

# so, what is `a` now?
puts a.inspect
p a

################################################################################
#2. Assign s to the string resulting from joining a on nothing.

s = a.join

# the `s` is:
puts s.inspect
p s

################################################################################
#3. Split s on whitespace and rejoin on nothing. Use the palindrome test from 
#   Listing 4.10 to confirm that the resulting string s is not a palindrome by 
#   the current definition. Using the downcase method, show that s.downcase is 
#   a palindrome.

p s.split( ' ' ).join

ws_s_s = s.split( ' ' )
p ws_s_s
ws_s_s_j = ws_s_s.join
p ws_s_s_j

def palindrome_tester(s)
  if s == s.reverse
    puts "It's a palindrome!"
  else
    puts "It's not a palindrome."
  end
end

palindrome_tester( ws_s_s_j )

p s.split( ' ' ).join.downcase

ws_s_s_j_dc = ws_s_s_j.downcase
p ws_s_s_j_dc

palindrome_tester( ws_s_s_j_dc )

################################################################################
#4.1. What is the result of selecting element 7 from the range of letters a 
#   through z? 

p ('a'..'z').to_a[7]

#4.2. What about the same range reversed? 

p ('a'..'z').to_a.reverse[7]

################################################################################
