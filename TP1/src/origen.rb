require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :fuente, :target, :premethods, :postmethods, :real_method, :parameters, :injected_parameters, :metodosATransformar

  def initialize(fuente)
    @fuente = fuente
    @target = nil
    @premethods = nil
    @postmethods = nil
    @core_method = nil
    @parameters = nil
    @injected_parameters = nil
  end

  def where(*condiciones)
    self.all_methods.select do
    |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end

  def transform(*metodos_filtrados, &bloque)

      metodosATransformar  = metodos_filtrados
      instance_eval(&bloque)


  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target().private_instance_methods + target().public_instance_methods
  end


end