module Condicion

  def name (reg_ex)
    proc {|a_method| a_method.to_s =~ reg_ex}
  end

  def is_public
    proc {|a_method| self.target.public_instance_methods.include? a_method}
  end

  def is_private
    proc {|a_method| self.target.public_instance_methods.__id__ a_method}
  end

  def neg (condition)
    proc{|a_method| not(condition.call a_method)}
  end

  def has_parameters(cant, arg_type = optional_mandatory)
    condition = arg_type.instance_of?(Regexp) ?  name(arg_type) : arg_type##TODO name(arg_type) en vez de type_regex(arg_type)
    proc {|a_method| instance_method(a_method).parameters.count &condition == cant}

  end

  def type_regex(regex)
    proc{|_,nom|  nom =~ regex }
  end
  def mandatory
    proc {|mode,_| mode == :req }
  end
  def optional
    proc{|mode,_| mode == :opt}
  end
  def optional_mandatory
   proc{true}
  end

end
