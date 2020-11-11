# frozen_string_literal: true

module Enumerable
  # my_each
  def my_each
     return to_enum(__method__) unless block_given?
  
     i = 0
     while i < size
       is_a?(Range) ? yield(min + i) : yield(self[i])
       i += 1
     end
     self
  end

  #  [1, 2, 3].my_each { |elem| print "#{elem + 1} " }

  # my_each_with_index
  def my_each_with_index
    return to_enum(__method__) unless block_given?

    y = 0
    my_each do |x|
      yield x, y
      y += 1
    end
  end

  # print [1, 2, 3].my_each_with_index { |elem, idx| puts "#{elem} : #{idx}" } 
  # my_select
  def my_select(arg = nil)
    arr = []
    unless block_given?
       if arg.is_a?(Proc)
         my_each do |elem| 
          if arg.call(elem)
            arr << elem 
          end
          end
       end
    end
    if block_given?
        my_each do |elem|
       if yield(elem)
        arr << elem
       end
      end
    end
    arr
  end

  # p [1, 2, 3, 8].my_select(&:even?) # => [2, 8]
  # p [0, 2018, 1994, -7].my_select { |n| n > 0 } # => [2018, 1994]
  # p [6, 11, 13].my_select(&:odd?) # => [11, 13]

  # my_map
  def my_map(proc = nil)
    arr = []
unless block_given?
    if proc.is_a?(Proc)
    my_each do |x| 
      arr << proc.call(x)
      end
    end
end
    if block_given?
      my_each do |x| 
        arr << yield(x) 
      end
    end
    arr
  end

# p [1, 2, 3].my_map { |n| 2 * n } # => [2,4,6]
# p %w[Hey Jude].my_map { |word| word + '?' } # => ["Hey?", "Jude?"]
# p [false, true].my_map(&:!) # => [true, false]
# my_proc = proc { |num| num == 10 }
# p [18, 22, 5, 6].my_map(my_proc) { |num| num > 10 } # => true true false false
 # my_all?
  def my_all?(var = nil)
    c = true
  unless block_given?
    if var.is_a?(Proc) 
     my_each { c = false unless var.call }
    
    elsif var.is_a?(Regexp)
    my_each {|x| c = false unless var.match?(x.to_s) }
    elsif var.is_a?(Class)
      my_each {|x| return  c = false if x != x.to_i }
    end
  end
    if block_given?
    my_each do |e|
      c = false unless yield(e) 
    end
    end
     c
  end
# p [3, 5, 7, 11].my_all?(&:odd?) # => true
# p [-8, -9, -6].my_all? { |n| n < 0 } # => true
# p [3, 5, 8, 11].my_all?(&:odd?) # => false
# p [-8, -9, -6, 0].my_all? { |n| n < 0 } # => false
# # test cases required by tse reviewer
# p [1, 2, 3, 4, 5].my_all? # => true
# p [1, 2, 3].my_all?(Integer) # => true
# p %w[dog door rod blade].my_all?(/d/) # => true
# p [1, 1, 1].my_all?(1) # => true

# my_any?
  def my_any?(arg=nil)
    if block_given?
      my_each { |item| return true if yield(item) == true }
    elsif arg.is_a?(Class)
      my_each { |item| return true if item.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      my_each { |item| return true if arg.match?(item.to_s)}
    elsif arg.nil? == false
      my_each { |item| return true if arg == item}
    else
      my_each { |item| return true if item }
    end
    false
  end
  # p [7, 10, 3, 5].my_any?(&:even?) # => true
  # p [7, 10, 4, 5].my_any?(&:even?) # => true
  # p %w[q r s i].my_any? { |char| 'aeiou'.include?(char) } # => true
  # p [7, 11, 3, 5].my_any?(&:even?) # => false
  # p %w[q r s t].my_any? { |char| 'aeiou'.include?(char) } # => false
  # # test cases required by tse reviewer
  # p [3, 5, 4, 11].my_any? # => true
  # p [1, nil, false].my_any?(1) # => true
  # p [1, nil, false].my_any?(Integer) # => true
  # p %w[dog door rod blade].my_any?(/z/) # => false
  # p [1, 2, 3].my_any?(1) # => true

  # my_none?
  def my_none?(arg=nil, &proc)
        !my_any?(arg, &proc)
      end
      
      # p [3, 5, 7, 11].my_none?(&:even?) # => true
      # p %w[sushi pizza burrito].my_none? { |word| word[0] == 'a' } # => true
      # p [3, 5, 4, 7, 11].my_none?(&:even?) # => false
      # p %w[asparagus sushi pizza apple burrito].my_none? { |word| word[0] == 'a' } # => false
      # # test cases required by tse reviewer
      # p [1, 2, 3].my_none? # => false
      # p [1, 2, 3].my_none?(String) # => true
      # p [1, 2, 3, 4, 5].my_none?(2) # => false
      # p [1, 2, 3].my_none?(4) # => true

# my_inject
  def my_inject(arg1=nil, arg2=nil)
    if block_given?
      if arg1.is_a?(Integer)
        my_each do |e|
          arg1 = yield(arg1, e)
        end
        return arg1
      elsif arg1.nil?
        acc = 0
        my_each do |e|
          acc = yield(acc, e)
        end
        return acc
      end
    end
    unless block_given?
      acc = 0
      if arg1 == '+'
        my_each do |e|
          acc += e
        end
        return acc
      end
    end
    unless block_given?
      acc = 1
      if arg2.to_sym == :*
        my_each do |e|
          acc *= e
        end
        return acc * arg1
      elsif arg1.nil?
        my_each do |e|
          acc *= e
        end
      else
        raise localjumpError, 'no block given' 
      end
      acc
    end
  end

# p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem } # => 20
# p [1, 2, 3, 4].my_inject { |accum, elem| accum + elem } # => 10
# p [5, 1, 2].my_inject('+') # => 8
# p (5..10).my_inject(2, :*) # should return 302400
# p (5..10).my_inject(4) { |prod, n| prod * n } # should return 604800
# p [1, 2, 3].inject
end

