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

  def inject(*hashes)

    parametros = target.instance_method(self.metodo_original).parameters.map{|p| p.last}
    ejecucion = lambda{|*param| self.send(self.metodo_alias, *param)}

    args = []

    bloque =  proc do
      hashes.each do
      |param, valor|
        args[parametros.index param] = valor
      end
      ejecucion.curry"#{args}" #Currifico para que la lambda me acepte un array como parametro

   end

    target.send(:define_method, self.metodo_original, *args, &bloque)
  end
end



