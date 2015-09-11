require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'

#estructuras para testear

class MiClase
  def foo
  end

  def bar
  end
end

describe 'Test de condiciones concretas' do

  let(:origen) {
    Origen.new(MiClase)
  }

  it 'name con (/fo{2}/) ' do
    selector = origen.where name(/fo{2}/)


    expect(selector).to contain_exactly(:foo)
  end
=begin
  it ' método foo (foo matchea ambas regex)' do
    selector = Aspect.on MiClase do
      where name(/fo{2}/)
    end

    expect(selector).to contain_exactly(:foo)
  end

  it 'ni bar ni foo matchean' do
    selector = Aspect.on MiClase do
      where name(/^fi+/)
    end

    expect(selector).to be_nil
  end

  it 'ni foo ni bar matchean ambas regex' do
    selector = Aspect.on MiClase do
      where name(/foo/), name(/bar/)
    end

    expect(selector).to be_nil
  end
=end

end
