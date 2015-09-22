class Transformacion

  def initialize(fuente, metodo_inicial)
    @real_method = @metodo = fuente.instance_method(metodo_inicial)
    @target = fuente
    @inject = {}
  end

  def transformate
    yield()


    metodo = @metodo
    real_method = @real_method
    after = @after
    before = @before
    inject = @inject
    @target.send(:define_method, real_method.name) do
    |*parametros|
       p parametros unless inject.empty?
       p inject unless inject.empty?
      metodo = metodo.bind(self) if metodo.is_a?(UnboundMethod)
      inject.each {|index,value| parametros[index]= value}

      sin_after = before.nil? ? instance_exec(*parametros, &metodo)
                              : instance_exec(*parametros, &before)

      after.nil? ? sin_after : instance_exec(*parametros, &after)

    end

  end

  def redirect_to(objetivo)
    real_method = @real_method.name
    @metodo = proc { |*parametros| objetivo.send(real_method, *parametros) }
  end

  def instead_of(&nuevo_metodo)
    @metodo = proc { |*parametros| instance_exec(self, *parametros, &nuevo_metodo) }
  end


  def after(&after)
    @after = proc { |*parametros| instance_exec(self, *parametros, &after) }
  end

  def before(&before)
    metodo = @metodo
    @before = proc { |*parametros|
      metodo = metodo.bind(self) if metodo.is_a?(UnboundMethod)
      continuacion = proc { |_, _, *new_parameters| metodo.call(*new_parameters) }
      instance_exec(self, continuacion, *parametros, &before) }
  end

  def inject(hasht)
    parametros = @real_method.parameters.map {|_,sym| sym}
    @inject = hasht.map {|key, value| [parametros.find_index { |p| p == key }, value]}
  end

end


=begin
def before(&logic)
  logic.call; self.fuente.send(self.metodo_alias)
end

def after(&logic)
  self.fuente.send(self.metodo_alias); logic.call
end

def instead_of(&logic)
  logic.call
end


def inject(*hash)
  proc { nuevos_parametros = get_nuevos_parametros(hash); self.fuente.send(self.real_method, *nuevos_parametros) }
end

def get_nuevos_parametros(*hash)
  viejos_parametros = self.method(self.real_method).parameters
  hash.each { |un_hash| self.set_hash(un_hash, viejos_parametros) }
end

#hash [(key,value)]
#viejos_parametros [(mode,key)]

def set_hash(hash, array)
end
#holita.method(:m).parameters .index(holita.method(:m).parameters.find { |l,sim| sim == :p2 })
=end