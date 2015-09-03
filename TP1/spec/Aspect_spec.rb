require 'rspec'
require_relative '../src/Aspect'
=begin
describe 'Aspect' do

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