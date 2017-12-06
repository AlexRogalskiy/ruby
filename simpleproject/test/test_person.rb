require 'minitest/autorun'
require 'person'

class TestPerson < Minitest::Test
	attr_accessor :person
	
	def setup
		@person = Person.new
		person.name = "B"
	end

	def teardown
		@person = nil
	end

	def test_intro
		#assert(person.intro == "Intro: B", "Person intro is not equal")
		assert_equal("Intro: B", person.intro)
		assert_includes([1, 2, 3], 3)
		assert_instance_of(String, "")
	end

	def test_argument_error
		assert_raises(ArgumentError) do
			raise ArgumentError, "ERROR"
		end
	end

	def test_runtime_error
		assert_raises(RuntimeError) do
			raise ""
		end
	end

end