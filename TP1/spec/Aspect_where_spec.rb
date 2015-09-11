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

describe 'Test de condiciones concretas unitarias' do

  let(:origen) {
    Origen.new(MiClase)
  }
#a
  it 'name con (/fo{2}/) ' do
    selector = origen.where name(/fo{2}/)
    expect(selector).to contain_exactly(:foo)
  end
=begin
  it ' método foo (foo matchea ambas regex)' do
    selector = origen.where name(/fo{2}/)
    end

    expect(selector).to contain_exactly(:foo)
  end

  it 'ni bar ni foo matchean' do
    selector = origen.where name(/^fi+/)
    end

    expect(selector).to be_nil
  end

  it 'ni foo ni bar matchean ambas regex' do
    selector = origen.where name(/foo/), name(/bar/)
    end

    expect(selector).to be_nil
  end
#b
 it 'metodo privado y regex bar' do
    visibility =origen.where name(/bar/), is_private

    expect(visibility).to contain_exactly(:bar)
    end

it 'bar no es publico' do
    visibility =origen.where name(/bar/), is_public

    expect(visibility).to be_nil
  end
#c
   it 'foo tiene 3 parametros mandatory' do
    sarlompa =origen.where has_parameters(3, mandatory)
    expect(sarlompa).to contain_exactly(:foo)
  end

  it 'foo es el unico con 6 parametros mandatory' do
    sarlompa =origen.where has_parameters(6)
    expect(sarlompa).to contain_exactly(:foo)
  end

  it 'foo y bar tienen 3 parametros optional' do
    sarlompa =origen.where has_parameters(6)
    expect(sarlompa).to contain_exactly(:foo)
  end
#d
  it 'foo y bar tienen 4 parametros que matchean con la regex' do
    sarlompa =origen.where (4, /p*/)
    expect(sarlompa).to contain_exactly(:foo, :bar)
  end

 it 'solo foo tienen 5 al menos parametros que matchean con la regex' do
    sarlompa =origen.where (5, /p*/)
    expect(sarlompa).to contain_exactly(:foo, :bar)
  end

  it 'nadie 7 al menos parametros que matchean con la regex' do
    sarlompa =origen.where (7, /p*/)
    expect(sarlompa).to be_nil
  end

end
=end




end
