module Println
  def println msg, obj = :none
    if obj == :none
      puts msg
    elsif obj.class == Float
      printf "%-15s: %.4f\n", msg, obj
    else
      printf "%-15s: %s\n", msg, obj
    end
  end
end
 
