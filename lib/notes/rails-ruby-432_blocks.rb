################################################################################
# Methods accepting Blocks: ####################################################
################################################################################
#1. Using the range 0..16, print out the first 17 powers of 2.

puts (0..16).map{ |e| "#{e}**2 = #{e**2}" }

################################################################################
#2. Define a method called yeller that takes in an array of characters and 
#   returns a string with an ALLCAPS version of the input. 
#   Verify that yeller([’o’, ’l’, ’d’]) returns "OLD". 
#   Hint/spoiler: Combine map, upcase, and join.

def yeller characters=[]
    characters.map{ |e| e.upcase }.join
end
a = %w( o l d )
p a
puts yeller a

################################################################################
#3. Define a method called random_subdomain that returns a randomly generated 
#   string of eight letters.

def random_subdomain
  ('a'..'z').to_a.shuffle[0..7].join
end
puts random_subdomain

################################################################################
#4. By replacing the question marks in the code below with the appropriate 
#   methods, combine split, shuffle, and join to write a function that shuffles 
#   the letters in a given string.
#
# def string_shuffle(s)
#   s.?('').?.?
# end
# string_shuffle("foobar")
# => "oobfra"

def string_shuffle(s)
  s.split('').shuffle.join
end
puts string_shuffle("foobar")

# Something to remember:

# Split's default separator is whitespace(s):
p "f o o      b a    r".split
# not characters:
p "foobar".split        # no split, BUT, interestingly, 
                        # returns "foobar" as an array ["foobar"]
                        # whereas "foobar".to_a will not    !!!   :)

# To split on characters, specify:
p "foobar baz".split('')

# To remove the whitespace:
p "foobar baz".split('').map{ |e| e.strip }.reject( &:empty? )
# strip whitespace before calling .reject( &:empty? )
# .reject( &:blank? ) alone would do in rails 
