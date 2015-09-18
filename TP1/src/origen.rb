require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion

  attr_accessor :fuente

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
      yiel
      Transformacion.new(target, metodo).transformate &bloque

    end
  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end


end
