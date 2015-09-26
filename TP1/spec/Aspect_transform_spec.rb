require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'

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



describe 'Test de condiciones concretas' do

  let(:origen) {
    Origen.new(A)
  }

  it 'redireccionar saludo' do

    origen.instance_eval {transform :saludar  do
      redirect_to(B.new)
    end
    }
DP    expect(A.new.saludar("Mundo")).to be_identical_string("Adiosin, Mundo")

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
  it 'foo' do
  Aspect.on MiClase do
    transform(where name(/m1/)) do
      before do |instance, cont, *args|
        @x = 10
        new_args = args.map{ |arg| arg * 10 }
        cont.call(self, nil, *new_args)
      end
    end
    end
  i=MiClase.new
  DP    expect(i.m1(1,2)).to be_eq(30)
    end
  end