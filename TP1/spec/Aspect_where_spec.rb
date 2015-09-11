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
    selector = origen.instance_eval { where name(/fo{2}/) }
    expect(selector).to contain_exactly(:foo)
  end

  it 'name con (/fo{2}/) ' do
    selector = origen.instance_eval { where name(/fo{2}/), name(/foo/) }
    expect(selector).to contain_exactly(:foo)
  end

  it ' metodo foo (foo matchea ambas regex)' do
    selector = origen.instance_eval { where name(/fo{2}/), name(/foo/) }
    expect(selector).to contain_exactly(:foo)
  end

  it 'ni bar ni foo matchean' do
    selector = origen.instance_eval { where name(/^fi+/) }
    expect(selector).to contain_exactly()
  end


  it 'ni foo ni bar matchean ambas regex' do
    selector = origen.instance_eval { where name(/foo/), name(/bar/) }
    expect(selector).to contain_exactly()
  end
#b
  it 'metodo privado y regex bar' do
    visibility =origen.instance_eval { where name(/bar/), is_private }
    expect(visibility).to contain_exactly(:bar)
  end

  it 'bar no es publico' do
    visibility =origen.instance_eval { where name(/bar/), is_public }
    expect(visibility).to contain_exactly()
  end


#c
   it 'foo tiene 3 parametros mandatory' do
    sarlompa = origen.instance_eval {where has_parameters(3, mandatory)}
    expect(sarlompa).to contain_exactly(:foo)
  end

  it 'foo es el unico con 6 parametros mandatory' do
    sarlompa =origen.instance_eval {where has_parameters(6)}
    expect(sarlompa).to contain_exactly(:foo)
  end

  it 'foo y bar tienen 3 parametros optional' do
    sarlompa =origen.instance_eval {where has_parameters(6)}
    expect(sarlompa).to contain_exactly(:foo)
  end
#d
  it 'foo y bar tienen 4 parametros que matchean con la regex' do
    sarlompa =origen.instance_eval {where has_parameters(4, /p*/)}
    expect(sarlompa).to contain_exactly(:bar)
  end

 it 'solo foo tienen 5 al menos parametros que matchean con la regex' do
    sarlompa =origen.instance_eval {where has_parameters(6, /p*/)}
    expect(sarlompa).to contain_exactly(:foo)
  end

  it 'nadie 7 al menos parametros que matchean con la regex' do
    sarlompa =origen.instance_eval {where has_parameters(7, /p*/)}
    expect(sarlompa).to contain_exactly()
  end


end
