require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'
require_relative '../src/transformacion'

#estructuras para testear
class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosin, " + x
  end
end


describe 'Test de transformaciones concretas' do

  let(:origen) {
    Origen.new(A)
  }
=begin



  it 'redireccionar saludo' do

    origen.instance_eval {transform :saludar  do
      redirect_to(B.new)
    end
    }
    expect(A.new.saludar("Mundo")).to be_identical_string("Adiosin, Mundo")

  end

=end
  it 'redireccionar basico' do
    optimus = Transformacion.new(A,:saludar)
    optimus.instance_eval { transformate {redirect_to(B.new)}}
    expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")

  end
=begin
  context 'redirect' do
    it 'redireccionar saludo' do
      Aspect.on A do
        transform(where name(/saludar/)) do
          redirect_to(B.new)
        end
      end

      expect(A.new.saludar("Mundo")).to be_identical_string("Adiosin, Mundo")
    end
  end

=end
end