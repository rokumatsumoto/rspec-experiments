require 'guessing_game_2'
require 'stringio'
require 'byebug'

RSpec.describe GuessingGame2 do
  describe '#play' do
    context 'when you have 3 guess' do
      let(:guessing_game_config) do
        instance_double(GuessingGameConfig2,
                        remaining_guess: 3,
                        guess_range: (1..100),
                        guess_range_str: '12')
      end
      let(:reader) { class_double(Reader) }
      let(:output) { StringIO.new }
      let(:random) { instance_double(Random, rand: 12) }

      let(:subject) { described_class.new(guessing_game_config, reader, output, random) }

      # before do
      #   allow(Random).to receive(:rand).with(guessing_game_config.guess_range)
      #                                   .and_return(12)
      # end

      it 'can find the number on first try' do
        $stdin = StringIO.new('12')
        allow(reader).to receive(:read_int).with($stdin).and_return(12)

        subject.play

        expect(subject.number).to eq(subject.guess)
        expect(output.string).to match(/You won!/)
      end

      it 'can find the number on second try' do
        $stdin = StringIO.new('11')
        allow(reader).to receive(:read_int).with($stdin).and_return(11, 12)

        subject.play

        expect(subject.number).to eq(subject.guess)
        expect(output.string).to include('11 is too low!').and include('You won!')
        expect(output.string).not_to include('12 is too low!')
      end

      it 'can\'t find the number on third try' do
        $stdin = StringIO.new('9')
        allow(reader).to receive(:read_int).with($stdin).and_return(9, 10, 11)

        subject.play

        expect(subject.number).not_to eq(subject.guess)
        expect(output.string).to include('9 is too low!')
          .and include('10 is too low!')
          .and include('11 is too low!')
          .and include('You lost!')
        expect(output.string).not_to include('You won!')
      end
    end
  end
end
