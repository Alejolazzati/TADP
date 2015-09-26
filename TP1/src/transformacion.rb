class Transformacion

  def initialize(fuente, metodo_inicial)
    @real_method = @metodo = fuente.instance_method(metodo_inicial)
    @target = fuente
    @inject = {}
  end

  def transformate(&bloquesin)
    instance_eval &bloquesin

    metodo = @metodo
    real_method = @real_method
    after = @after
    before = @before
    inject = @inject
    @target.send(:define_method, real_method.name) do
    |*parametros|

      metodo = metodo.bind(self) if metodo.is_a?(UnboundMethod)
      inject.each do |index, value|
        old_value = parametros[index]
        parametros[index] = value.is_a?(Proc) ? value.call(self, real_method.name, old_value) : value
      end



      sin_after = before.nil? ? instance_exec(*parametros, &metodo)
      : instance_exec(*parametros, &before)

      resultado =after.nil? ? sin_after : instance_exec(*parametros, &after)
      metodo = metodo.unbind if metodo.is_a?(Method) #para que no tenga efecto de lado haciendolo varias veces
      resultado
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
    p @real_method
    parametros = @real_method.parameters.map { |_, sym| sym }
    p "parametros"
    p parametros
    method_name = @real_method.name
    @inject = hasht.map { |key, value| [i = get_index(parametros,key), value] }
  end

  def get_index(parameters,key)
    p "key"
    p key
    index = parameters.find_index { |parameter|p "parameter" ;p(parameter) == key }
    index.nil? ? (raise ArgumentError.new 'Ese parametro no existe PAPA!') : index
  end

  def get_value(value,original_parameter,method_name)
    value.is_a?(Proc) ? value.call(self, method_name, original_parameter) : value
  end

end