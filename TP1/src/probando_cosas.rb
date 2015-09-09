
# se que esto que hago aca ahora se puede diseñar mucho mejor.
# es solo para ver como hacerlo andar e ir probando cosas

module A

  # aca le harcodeo una transformacion. Lo que hace es redefinir los mensajes que cumplan las
  # condiciones del where, haciendo devolver 'HOla'
  def transform (*param)
    param.flatten.each {|metodo| send(:define_method, metodo, proc{'HOla'})}
  end

  def where (*conditions)
      instance_methods.select{|a_method| allSatisfy(conditions, a_method)}
  end

  def allSatisfy (*conditions, a_method)
    conditions.flatten.all? {|a_condition| a_condition.call(a_method)}
  end

  def name (reg_ex)
    proc {|a_method| (a_method.to_s =~ reg_ex) == 0}
  end

  def is_public
    proc {|a_method| public_methods.include? a_method}
  end

  def is_private
    proc {|a_method| private_methods.include? a_method}
  end

  def public_and_private_methods
    instance_methods + private_methods
  end

  def has_parameters(n, tipo = proc{|unMetodo| instance_method(unMetodo).parameters})
    if tipo.instance_of? Regexp
      proc{|unMetodo| instance_method(unMetodo).parameters.select{|param| param.last =~ tipo}.length == n}
    else
      proc{ |unMetodo| tipo.call(unMetodo).length == n}
    end
  end

  def mandatory
    proc{|unMetodo| instance_method(unMetodo).parameters.select{|param| param.first == :req}}
  end

  def optional
    proc{|unMetodo| instance_method(unMetodo).parameters.select{|param| param.first == :opt}}
  end

  def neg (condition)
    proc{|a_method| not(condition.call a_method)}
  end

end

class Object
  def define_method (a, b)
    define_singleton_method a, b
  end

  def instance_methods
    methods
  end
end

# Al definir el metodo en Module, por herencia lo tiene Class
# => no es necesario porner el metodo definir_aspecto en Class, ya lo va a tener
# en Object si (hace otra cosa), Module hereda de este y el mismo redefine el metodo en cuestion.
# igualmente esto es solo para probar que ande. No es necesario este metodo en particular

#  class Module
#    def definir_aspecto(bloque)
#      self.send(:define_method, :nuevo_metodo, bloque)
#    end
#  end

#  class Objectc
#    def definir_aspecto (bloque)
#      self.singleton_class.send(:define_method, :nuevo_metodo, bloque)
#    end
#  end
