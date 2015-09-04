require 'rspec'
require_relative '../src/Aspect'

class Pepita_test

end

class Pepe_test

end

module A_test

end

module B_test

end

@pepita_test = Pepita_test.new
@pepe_test = Pepe_test.new

describe 'Aspect basic tests' do
  let(:expected_origins) {
    Array.new
  }

  it 'deberia devolver las clases cuando le mando solo clases' do
    expected_origins.push(Pepe_test,Pepita_test)
  expect(Aspect.select_origins(Pepe_test,Pepita_test,{})).to eq(expected_origins)
  end
=begin
  it 'deberia devolver mixins cuando le mando solo mixins' do

  end

  it 'deberia devolver unos objetos cuando le mando solo unos objetos' do

  end

end

=begin
  let(:una_golondrina) {
    Golondrina.new
  }



  it 'deberia perder energia cuando vuelva' do
    una_golondrina.volar(10)
    expect(una_golondrina.energia).to eq(900)
  end

  it 'deberia ganar energia cuando come' do
    una_golondrina.comer(5)
    expect(una_golondrina.energia).to eq(1025)

  end

end
=end
end