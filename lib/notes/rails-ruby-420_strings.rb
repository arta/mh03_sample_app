################################################################################
# Strings: #####################################################################
################################################################################
#1. Assign variables city and state to your current city and state of 
#   residence. (If residing outside the U.S., substitute the analogous 
#   quantities.)

city = 'La Crosse'
state = 'WI'

################################################################################
#2. Using interpolation, print (using puts) a string consisting of the city and
#   state separated by a comma and as space, as in “Los Angeles, CA”.

puts "#{city}, #{state}"

################################################################################
#3. Repeat the previous exercise but with the city and state separated by 
#   a tab character.

puts "#{city}\t#{state}"

################################################################################
#4. What is the result if you replace double quotes with single quotes in
#   the previous exercise?

puts '#{city}\t#{state}'
puts '#{city}\t#{state}'.inspect
p '#{city}\t#{state}'
p "#{city}\t#{state}"

################################################################################



################################################################################
#1. What is the length of the string “racecar”?

puts "racecar".length

################################################################################
#2. Confirm using the reverse method that the string in the previous exercise is
#   the same when its letters are reversed.

puts "racecar".reverse

################################################################################
#3. Assign the string “racecar” to the variable s. Confirm using the comparison 
#   operator == that s and s.reverse are equal.

s = "racecar"
puts "racecar" == "racecar".reverse

################################################################################
#4.1. What is the result of running the code shown below? 
#   puts "It's a palindrome!" if s == s.reverse

puts "It's a palindrome!" if s == s.reverse

#4.2. How does it change if you reassign the variable s to the string 
#   “onomatopoeia”?

s = "onomatopoeia"
puts "It's a palindrome!" if s == s.reverse

################################################################################



################################################################################
#1. By replacing FILL_IN with the appropriate comparison test shown below, 
#   define a method for testing palindromes.
#
# def palindrome_tester(s)
#   if FILL_IN
#     puts "It's a palindrome!"
#   else
#     puts "It's not a palindrome."
#   end
# end

def palindrome_tester(s)
  if s == s.reverse
    puts "It's a palindrome!"
  else
    puts "It's not a palindrome."
  end
end

################################################################################
#2. By running your palindrome tester on “racecar” and “onomatopoeia”, confirm 
#   that the first is a palindrome and the second isn’t.

palindrome_tester( "racecar" )
palindrome_tester( "onomatopoeia" )

################################################################################
#3. By calling the nil? method on palindrome_tester("racecar"), confirm that 
#   its return value is nil (i.e., calling nil? on the result of the method 
#   should return true). This is because the code in Listing 4.10 prints its 
#   responses instead of returning them.

palindrome_tester( "racecar" ).nil? #<= ... nope 

################################################################################
