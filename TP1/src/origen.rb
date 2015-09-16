require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :fuente, :metodo_original, :metodo_alias, :lista_hashes

  class << self
    attr_accessor :claves, :valores, :parametros
  end

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
    nuevo_nombre = self.metodo_alias(metodo)
    self.target.send(:alias_method, nuevo_nombre, metodo) unless (target.instance_methods.include? nuevo_nombre)

    bloque = proc do
      |sym, *args|
      super(sym, *args) unless respond_to? sym
      self.send((sym.to_s + '_alias').to_sym, *args)
    end
    self.target.send(:define_method, :method_missing, &bloque)
    nuevo_nombre
  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end

  def metodo_alias(metodo)
    (metodo.to_s + '_alias').to_sym
  end
end

