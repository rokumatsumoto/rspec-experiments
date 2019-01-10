require 'guessing_game'
require 'stringio'
require 'byebug'

RSpec.describe GuessingGame do
  describe '#play' do
    context 'when you have 3 guess' do
      it 'exits on the first guess if it is correct' do
        output = play(12, [12])

        expect(output).to eq unindent(<<-OUT)
          Pick a number 1..100 (3 guesses left):
          You won!
        OUT
      end

      it 'tells the user if their guess is too low' do
        output = play(12, [11, 12])

        expect(output).to eq unindent(<<-OUT)
          Pick a number 1..100 (3 guesses left):
          11 is too low!
          Pick a number 1..100 (2 guesses left):
          You won!
        OUT
      end

      it 'tells the user if their guess is too high' do
        output = play(12, [33, 12])

        expect(output).to eq unindent(<<-OUT)
          Pick a number 1..100 (3 guesses left):
          33 is too high!
          Pick a number 1..100 (2 guesses left):
          You won!
        OUT
      end

      specify 'the player loses if they miss 3n guesses' do
        output = play(12, [9, 45, 33])

        expect(output).to eq unindent(<<-OUT)
          Pick a number 1..100 (3 guesses left):
          9 is too low!
          Pick a number 1..100 (2 guesses left):
          45 is too high!
          Pick a number 1..100 (1 guesses left):
          33 is too high!
          You lost! The number was: 12
        OUT
      end
    end
  end

  def play(rand_number, guesses)
    guessing_game_config = instance_double(GuessingGameConfig,
                                           remaining_guess: 3,
                                           guess_range: (1..100),
                                           guess_range_str: (1..100).to_s)
    input = StringIO.new(guesses.join("\n"))
    output = StringIO.new
    random = instance_double(Random, rand: rand_number)
    GuessingGame.new(guessing_game_config, output, random, input).play
    output.string
  end

  def unindent(str)
    str.gsub(/^#{str.scan(/^[ \t]+(?=\S)/).min}/, '')
  end
end
