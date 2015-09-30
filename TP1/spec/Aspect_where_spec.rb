require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'

#estructuras para testear
class MiClase
  def foo(p1, p2, p3, p4='a', p5='b', p6='c')
  end

  private
  def bar(p1, p2='a', p3='b', p4='c')
  end
end

describe 'Test de condiciones concretas' do

  let(:origen) {
    Origen.new(MiClase)
  }

  let(:aspect) do
    proc do
    |&b|
      Aspect.on MiClase do
        instance_eval &b
      end
    end
  end

  it 'name con (/fo{2}/) ' do
    expect(aspect.call {where name(/fo{2}/) }).to contain_exactly(:foo)
  end

  it 'name con (foo matchea ambas regex)' do
    expect(aspect.call {where name(/fo{2}/), name(/foo/) }).to contain_exactly(:foo)
  end

  it 'ni bar ni foo matchean' do
    expect(aspect.call {where name(/^fi+/)}).to contain_exactly()
  end


  it 'ni foo ni bar matchean ambas regex' do
    expect(aspect.call {where name(/foo/), name(/bar/)}).to contain_exactly()
  end

  it 'metodo privado y regex bar' do
    expect(aspect.call {where name(/bar/), is_private }).to contain_exactly(:bar)
  end

  it 'bar no es publico' do
    expect(aspect.call { where name(/bar/), is_public }).to contain_exactly()
  end


  it 'foo tiene 3 parametros mandatory' do
    expect(aspect.call { where has_parameters(3, mandatory) }).to contain_exactly(:foo)
  end

  it 'foo es el unico con 6 parametros mandatory' do
    expect(aspect.call { where has_parameters(6) }).to contain_exactly(:foo)
  end

  it 'foo y bar tienen 3 parametros optional' do
    expect(aspect.call { where has_parameters(3,optional) }).to contain_exactly(:foo, :bar)
  end

  it 'foo y bar tienen 4 parametros que matchean con la regex' do
    expect(aspect.call { where has_parameters(4, /p*/) }).to contain_exactly(:bar)
  end

  it 'solo foo tienen 5 al menos parametros que matchean con la regex' do
    expect(aspect.call { where has_parameters(6, /p*/) }).to contain_exactly(:foo)
  end

  it 'nadie 7 al menos parametros que matchean con la regex' do
    expect(aspect.call {where has_parameters(7, /p*/) }).to contain_exactly()
  end


end
