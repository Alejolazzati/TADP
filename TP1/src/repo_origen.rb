#@DEPRECATED
class RepoOrigen

  attr_accessor :origenes, :impostores
#TODO refactorizar esta mierda y evitar todos los each do
  def initialize(*origenes)
    @origenes = origenes
    imposteres = Array.new()
    origenes.each {|origen| impostores.add(Origen.new(origen)) }
  end

  def where(*condiciones)
    impostores.each do
    |impostor|
        impostor.filtraMetodos(condiciones)
    end

  end


    def transform(*impostores,&transformaciones)
      impostores.each do
      |impostor|
        impostor.transformar (&transformaciones)
      end
    end

  end


end