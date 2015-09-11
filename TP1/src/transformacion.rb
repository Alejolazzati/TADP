module Transformacion

  def before(&logic)
    logic.call; self.fuente.send(self.metodo_alias)
  end

  def after(&logic)
    self.fuente.send(self.metodo_alias); logic.call
  end

  def instead_of(&logic)
    logic.call
  end

  def redirect_to(objetivo)
    proc {objetivo.send(self.real_method)}
  end

  def inject(*hash)
    proc {nuevos_parametros = get_nuevos_parametros(hash);self.fuente.send(self.real_method, *nuevos_parametros)}
  end

  def get_nuevos_parametros(*hash)
    viejos_parametros = self.method(self.real_method).parameters
    hash.each {|hash|self.set_hash(hash,viejos_parametros) }
  end

#hash [(key,value)]
#viejos_parametros [(mode,key)]

  def set_hash(hash,array)

  end
  #holita.method(:m).parameters .index(holita.method(:m).parameters.find { |l,sim| sim == :p2 })

end