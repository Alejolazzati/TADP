module Transformacion

  def inject(*hashes)

    nuevo_origen = Origen.new()
    nuevo_origen.origen_padre = self
    nuevo_origen.hashes = hashes.first

    bloque = proc do
      |una_instancia, *args|

      parametros = self.origen_padre.metodos[__method__].parameters.map {|p| p.last}

      self.hashes.each do
        |hash|

        clave = hash.first
        valor = hash.last

        pos = parametros.index clave

        args[pos] = if valor.is_a? Proc
                      valor.call(self.origen_padre.fuente, __method__, args[pos])
                    else
                      valor
                    end
      end

      if fuente != nil
        self.fuente.send(__method__, una_instancia, *args)
      else
        self.origen_padre.metodos[__method__].bind(una_instancia).call(*args)
      end
    end

    nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &bloque)

    self.agregar_origen_para(self.metodo.name, nuevo_origen)

  end
end

def redirect_to(receptor)
  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.receptor = receptor

  bloque = proc do
  |una_instancia, *args|
      self.receptor.send(__method__, *args)
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &bloque)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def before(&logica)

  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.logica = logica

  comportamiento = proc do
  |una_instancia, *args|
    resultado = una_instancia.instance_exec(*args, &self.logica)

    if self.fuente != nil
      self.fuente.send(__method__, una_instancia, *resultado)
    else
      self.origen_padre.metodos[__method__].bind(una_instancia).call(*resultado)
    end
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &comportamiento)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def after(&logica)

  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.logica = logica

  comportamiento = proc do
  |una_instancia, *args|
    self.origen_padre.metodos[__method__].bind(una_instancia).call(*args)
    una_instancia.instance_exec(*args, &self.logica)
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &comportamiento)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def instead_of(&logica)

  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.logica = logica

  comportamiento = proc do
  |una_instancia, *args|
    una_instancia.instance_exec(*args, &self.logica)
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &comportamiento)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

