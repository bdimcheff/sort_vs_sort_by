require 'benchmark'
require 'enumerator'

list = (1..100000).map { rand(100000) }

puts
puts "sort and sort_by with fast comparisons:"
gets

Benchmark.bm(10) do |b|
  b.report("sort")    { list.dup.sort }
  b.report("sort_by") { list.dup.sort_by {|x| x } }
end

class Foo
  attr_accessor :val
  
  def initialize(val)
    @val = val
  end
end

list = (1..100000).map {|i| 
  Foo.new(i)
}.sort_by { rand }

puts
puts "sort and sort_by with slow comparisons:"
gets

# Even something as simple as method dispatch is slow enough to make sort_by faster than sort
Benchmark.bm(10) do |b|
  b.report("sort")    { list.dup.sort {|x, y| x.val <=> y.val} }
  b.report("sort_by") { list.dup.sort_by {|x| x.val } }
end

# Make foo print a message whenever the accessor is called
class Foo
  def val
    puts "calling val: #{@val}"
    @val
  end
end

list = %w{a 2 r b}.map {|i| Foo.new(i)}

puts
puts "sort:"
gets

list.dup.sort {|x, y| x.val <=> y.val}

puts
puts "sort_by:"
gets

list.dup.sort_by {|x| x.val }

module Enumerable
  # This is essentially the implementation of sort_by
  # It's written in C in MRI, so it's a little faster
  def my_sort_by
    self.map {|i| [yield(i), i]}.sort.map {|j| j[1]}
  end
end

puts
puts "my_sort_by:"
gets

list.dup.my_sort_by {|x| x.val }

list = (1..100000).map {|i| Foo.new(i)}.sort_by { rand }

class Foo
  def val
    # do something superfluous
    (1..5).map {|i| i**i}
    @val
  end
end

puts
puts "sort, sort_by, and my_sort_by with slow comparisons:"
gets
list.dup.my_sort_by {|x| x.val }

Benchmark.bm(10) do |b|
  b.report("sort")    { list.dup.sort {|x, y| x.val <=> y.val} }
  b.report("sort_by") { list.dup.sort_by {|x| x.val } }
  b.report("my_sort_by") { list.dup.my_sort_by {|x| x.val } }
end

