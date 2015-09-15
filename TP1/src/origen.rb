require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :fuente, :metodo_original, :metodo_alias, :lista_hashes

  def initialize(fuente)
    @fuente = fuente
    @lista_hashes = []
  end

  def where(*condiciones)
    self.all_methods.select do
      |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end

  def transform(*metodos_filtrados, &transformaciones)
    metodos_filtrados.flatten.each do
      |metodo|

      self.metodo_original = metodo
      self.metodo_alias = self.definir_metodo_alias(metodo)

      self.instance_eval &transformaciones
    end
  end

  def definir_metodo_alias(metodo)
    nuevo_nombre = (metodo.to_s + '_alias').to_sym
    self.target.send(:alias_method, nuevo_nombre, metodo) unless (target.instance_methods.include? nuevo_nombre)
    nuevo_nombre
  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end


end
