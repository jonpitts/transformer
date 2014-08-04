
#extend String class to check if string is numeric
class String
  def numeric?
    Float(self) != nil rescue false
  end
end
