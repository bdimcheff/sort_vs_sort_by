require 'benchmark'
require 'enumerator'

class Foo
  attr_accessor :val
  
  def initialize(val)
    @val = val
  end
end

list = (1..100000).map {|i| 
  Foo.new(i)
}

puts
puts "Fast comparisons:"
gets

Benchmark.bm(10) do |b|
  b.report("Sort")    { list.dup.sort {|x, y| x.val <=> y.val} }
  b.report("Sort by") { list.dup.sort_by {|x| x.val } }
end

class Foo
  def val
    # do something superfluous
    (1..10).map {|i| i**i}
    @val
  end
end

puts
puts "Slow comparisons:"
gets

Benchmark.bm(10) do |b|
  b.report("Sort")    { list.dup.sort {|x, y| x.val <=> y.val} }
  b.report("Sort by") { list.dup.sort_by {|x| x.val } }
end

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
  def my_sort_by
    self.map {|i| [yield(i), i]}.sort.map {|j| j[1]}
  end
end

puts
puts "my_sort_by:"
gets

list.dup.my_sort_by {|x| x.val }

list = (1..100000).map {|i| Foo.new(i)}

class Foo
  def val
    # do something superfluous
    (1..10).map {|i| i**i}
    @val
  end
end

puts
puts "my_sort_by with slow comparisons:"
gets
list.dup.my_sort_by {|x| x.val }

Benchmark.bm(10) do |b|
  b.report("Sort")    { list.dup.sort {|x, y| x.val <=> y.val} }
  b.report("Sort by") { list.dup.sort_by {|x| x.val } }
  b.report("My sort by") { list.dup.my_sort_by {|x| x.val } }
end

