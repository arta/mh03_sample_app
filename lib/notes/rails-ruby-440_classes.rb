################################################################################
# Classes: #####################################################################
################################################################################
#1. What is the literal constructor for the range of integers from 1 to 10?

r = 1..10
p r

################################################################################
#2. What is the constructor using the Range class and the new method? 
#   Hint/spoiler: new takes two arguments in this context.

r1 = Range.new( 1, 10 )
p r1

################################################################################
#3. Confirm using the == operator that the literal and named constructors from 
#   the previous two exercises are identical.

p r == r1

################################################################################



################################################################################
#1. What is the class hierarchy for a range? For a hash? For a symbol?

r = Range.new( 1, 5 )
p r.class
p r.class.superclass
p r.class.superclass.superclass
p r.class.superclass.superclass.superclass
h = Hash.new
p h.class
p h.class.superclass
p h.class.superclass.superclass
s = :symbol
p s.class
p s.class.superclass
p s.class.superclass.superclass

################################################################################
#2. Confirm that the Word#palindrome method works even if we replace 
#   self.reverse with just reverse.
#
# class Word < String             # Word inherits from String.
#   # Returns true if the string is its own reverse.
#   def palindrome?
#     self == self.reverse        # self is the string itself.
#   end
# end

class Word < String
  def palindrome?
    self == reverse
  end
end

w = Word.new( 'racecar' )
p w.palindrome?
w2 = Word.new( 'racer' )
p w2.palindrome?

################################################################################




################################################################################
#1. Verify that “racecar” is a palindrome and “onomatopoeia” is not. What about 
#   the name of the South Indian language “Malayalam”? 
#   Hint/spoiler: Downcase it first.

# Amazingly, Ruby classes can be opened and modified, allowing ordinary mortals 
# such as ourselves to add methods to them:

class String
  def palindrome?
    self == reverse
  end
end
p 'racecar'.palindrome?
p 'onomatopoeia'.palindrome?

################################################################################
#2. Using String#shuffle as a guide, add a shuffle method to the String class. 
#   Hint: Refer to ruby-rails-432_block.rb
#
#   class String
#     def shuffle
#       self.?('').?.?
#     end
#   end
#   "foobar".shuffle
#   => "borafo"

class String
  def shuffle
    self.split('').shuffle.join
  end
end
p "foobar".shuffle

################################################################################
#3. Verify that String#shuffle works even if you remove self.

class String
  def shuffle
    split('').shuffle.join
  end
end
p "foobar".shuffle

################################################################################



################################################################################
controller = StaticPagesController.new
