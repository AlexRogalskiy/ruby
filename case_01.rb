class Age
    include Comparable

    attr_accessor(:age)

    def <=>(cmp)
        @age <=> cmp.age
    end
end

a, b = Age.new, Age.new
a.age = 10
b.age = 11
if a < b then puts "a меньше, чем b." end