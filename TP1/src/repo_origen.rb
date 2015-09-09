class RepoOrigen

  include condicion
  include transformacion

  attr_accessor :origenes

  def initialize(*origenes)
    @origenes = origenes
  end



end