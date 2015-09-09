class RepoOrigen

  include condicion
  include transformacion

  attr_accessor :origenes, :impostores

  def initialize(*origenes)
    @origenes = origenes
    imposteres = Array.new()
    origenes.each {|origen| impostores.add(Impostor.new(origen)) }
  end



end