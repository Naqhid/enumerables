module Enumerable

  def my_each(&p)
    return enum_for(__method__) unless block_given?

    for i,k in self
    p.call(i,k)
    end
  end

# [1,2,3,4,5].my_each {|x| puts x }
def my_each_with_index()
  return to_enum(__method__) unless block_given?
  y=-1
  self.my_each do|x| 
   y+=1
  yield x,y
end
end
#  [1,2,3,4,5].my_each_with_index {|x,y| puts x,y}

end
