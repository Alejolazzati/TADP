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

class MiClase
  attr_accessor :x

  def m1(x, y)
    x + y
  end

  def m2(x)
    @x = x
  end

  def m3(x)
    @x = x
  end
end

describe 'Test de transformaciones concretas' do

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
    optimus = Transformacion.new(A, :saludar)
    optimus.instance_eval { transformate { redirect_to(B.new) } }
    expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")

  end

    it 'instead of' do
      optimus = Transformacion.new(MiClase, :m3)
      optimus.instance_eval { transformate { instead_of do |instance, *args|
        @x = 123
        p @x
      end } }
      expect(MiClase.new.m3(10)).to eq(123)
      instancia.m3(10)
      expect(instancia.x).to eq(123)

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