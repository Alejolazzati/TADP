require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'
require_relative '../src/transformacion'

#estructuras para testear

describe 'Test de transformaciones "integradoras"' do
  before(:each) do
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

      def hace_algo(p1, p2)
        p1 + '-' + p2
      end

      def hace_otra_cosa(p2, ppp)
        p2 + ':' + ppp
      end
    end
  end
  let (:instancia) do
    instancia = MiClase.new
  end

  it 'redireccionar saludo' do
    Aspect.on A do
      transform(where name(/saludar/)) do
        redirect_to(B.new)
      end
    end

    expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")
  end


  it 'instead of' do
    Aspect.on MiClase do
      transform(where name(/m3/)) do
        instead_of do |instance, *args|
          @x = 123
        end
      end
    end

    expect(MiClase.new.m3(10)).to eq(123)
    instancia.m3(10)
    expect(instancia.x).to eq(123)
  end

=begin
  it 'after' do
    optimus = Transformacion.new(MiClase, :m2)
    optimus.instance_eval { transformate { after do |instance, *args|
      if @x > 100
        2 * @x
      else
        @x
      end
    end
    } }
    instancia = MiClase.new

    expect(instancia.m2(10)).to eq(10)
    expect(instancia.m2(200)).to eq(400)
  end

  it 'before' do
    optimus = Transformacion.new(MiClase, :m1)
    optimus.instance_eval { transformate { before do |instance, cont, *args|
      @x = 10
      new_args = args.map { |arg| arg * 10 }
      cont.call(self, nil, *new_args)
    end } }
    instancia = MiClase.new
    expect(instancia.m1(1, 2)).to eq(30)
    expect(instancia.x).to eq(10)

  end

  it 'inject' do
    optimus = Transformacion.new(MiClase, :hace_algo)
    optimus.instance_eval { transformate { inject(p2: 'bar') } }
    instancia = MiClase.new
#    expect(instancia.hace_algo("foo")).to eq("foo-bar") deberia poder recibir un param menos?
    expect(instancia.hace_algo("foo", "foo")).to eq("foo-bar")
  end

  it 'inject2' do
    optimus = Transformacion.new(MiClase, :hace_otra_cosa)
    optimus.instance_eval { transformate { inject(p2: 'bar') } }
    instancia = MiClase.new
    expect(instancia.hace_otra_cosa("foo", "foo")).to eq("bar:foo")
  end

  context 'redirect' do

  end



  it 'transformacion compuesta del enunciado' do
    optimus = Transformacion.new(B, :saludar)
    optimus.instance_eval { transformate { inject(x: "Tarola"); redirect_to(A.new) } }

    expect(B.new.saludar("Mundo")).to eq("Hola, Tarola")
  end
=end
end