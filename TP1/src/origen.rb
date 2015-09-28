require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion


  attr_accessor :fuente, :real_method, :metodo_alias

  def initialize(fuente)
    @fuente = fuente
  end

  def where(*condiciones)
    self.all_methods.select do
      |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end

  def transform(*metodos_filtrados, &bloque)
    metodos_filtrados.each do
      |metodo|
      @real_method = metodo
      target.send(:alias_method, :old_method, metodo) #quizas metodo.to_sym
      @metodo_alias = :old_method
      transformacion = proc {|method, logic_transformada| self.target.send(:define_method, method, logic_transformada)}#quizas haya que hacer fuente.target.send
      transformacion.call(metodo,bloque)#quizas sin &
    end

  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end

  def agregarContinuacion(&bloque)
  proc do |instance, cont, *args|
    instance.instance_exec(*args,&bloque)
    cont.call(instance,*args)

  end

  end
  
  end

