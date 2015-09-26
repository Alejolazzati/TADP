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
    @target.send(:define_method, real_method.name) do
    |*parametros|
      metodo1 =  metodo.is_a?(UnboundMethod) ? metodo.bind : metodo
      instance_exec(*parametros, &metodo1)
    end
  end

  def redirect_to(objetivo)
    real_method = @real_method.name
    @metodo = before do |instance, cont, *args|
      objetivo.send(real_method, *args)
    end
  end

  def instead_of(&nuevo_metodo)
    @metodo = before do |instance, cont, *args|
      instance_exec(instance, *args, &nuevo_metodo)
    end
  end

  def after(&after)
    metodo = @metodo
    @metodo =before do |instance, cont, *args|
      cont.call(instance, metodo, *args)
      instance_exec(instance, *args, &after)
    end
  end

  def before(&before)
    metodo = @metodo
    @metodo = proc { |*parametros|
#     metodo1 =  metodo.is_a?(UnboundMethod) ? metodo.bind : metodo
 #     metodo = metodo.unbind if metodo.is_a?(Method)
     metodo = metodo.bind(self) if metodo.is_a?(UnboundMethod)

      continuacion = proc { |instancia, cont, *new_parameters| metodo.call(*new_parameters) } #REVISAR
      instance_exec(self, continuacion, *parametros, &before) }
  end

  def inject(hasht)
    parametros = @real_method.parameters.map { |_, sym| sym }
    new_args= hasht.map { |key, value| [get_index(parametros, key), value] }
    method_name = @real_method.name
    before do |instance, cont, *args|

      new_args.each do |index, value|
        old_value = args[index]
        args[index] = value.is_a?(Proc) ? value.call(self, method_name, old_value) : value
      end
      cont.call(self, nil, *args)
    end
  end

  def get_index(parameters, key)
    index = parameters.find_index { |parameter| parameter == key }
    index.nil? ? (raise ArgumentError.new 'Ese parametro no existe PAPA!') : index
  end

  def get_value(value, original_parameter, method_name)
    value.is_a?(Proc) ? value.call(self, method_name, original_parameter) : value
  end

end