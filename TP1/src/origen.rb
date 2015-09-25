require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :metodos ,:fuente

  def initialize(fuente)
    @fuente = fuente
    @metodos=Array.new

  end

  def where(*condiciones)
    self.all_methods.select do
      |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end
  def transform(metodos_filtrados, &bloque)
    target.send(:__cont__=,100)
   @metodos=metodos_filtrados

    bloque.call()
  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end


end

