class Impostor

  attr_accessor :origen, :metodos_filtrados

  def initialize(origen)
    @origen = origen
  end

  def metodos_filtrados(*condiciones)
    @metodos_filtrados = self.all_methods.select do
    |method|
        condiciones.all? {|condicion|condicion.call(method)}
      end
  end


  def target()
    if (self.instance_of?(Class) || self.instance_of?(Module))
      self
    else
      self.singleton_class
    end
  end

  def all_methods()
    return target.private_instance_methods + target.public_instance_methods
  end


end