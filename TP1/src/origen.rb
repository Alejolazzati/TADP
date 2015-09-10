class Origen

  include condicion
  include transformacion

  attr_accessor :fuente, :metodos_filtrados

  def initialize(fuente)
    @fuente = fuente
  end

  def where(*condiciones)
    @metodos_filtrados = self.all_methods.select do
    |method|
        condiciones.all? {|condicion|condicion.call(method)}
    end

  end

  def transform(&bloque)
    @metodos_filtrados.each do
    |metodo|
      self.instance_exec(metodo,&bloque)
      self.transformar_posta(metodo)
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