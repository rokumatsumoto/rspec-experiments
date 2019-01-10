require 'byebug'
class GuessingGame2
  attr_reader :guess, :number

  def initialize(game_config = GuessingGameConfig2.new, reader = Reader,
                 output = $stdout, random = Random.new)
    @guess = nil
    @game_config = game_config
    @reader = reader
    @output = output
    @number = random.rand(@game_config.guess_range)
  end

  def play
    @game_config.remaining_guess.downto(1) do |remaining_guesses|
      break if @guess == number

      display "Pick a number #{@game_config.guess_range_str} "\
      "(#{remaining_guesses} guesses left):"

      @guess = @reader.read_int($stdin)
      check_guess
    end
    announce_result
  end

  private

  def display(value)
    @output.puts value
  end

  def check_guess
    if @guess > number
      display "#{@guess} is too high!"
    elsif @guess < number
      display "#{@guess} is too low!"
    end
  end

  def announce_result
    if @guess == number
      display 'You won!'
    else
      display "You lost! The number was: #{number}"
    end
  end
end

class GuessingGameConfig2
  def initialize(remaining_guess = 5, guess_range = (1..100).freeze)
    @remaining_guess = remaining_guess
    @guess_range = guess_range
  end

  attr_reader :remaining_guess

  attr_reader :guess_range

  def guess_range_str
    guess_range.to_s
  end
end

class Reader
  def self.read_int(input_stream = $stdin)
    input = input_stream.gets
    input[/^\d+$/] && input.to_i
  end
end

# play the game if this file is run directly
GuessingGame2.new(GuessingGameConfig2.new).play if __FILE__.end_with?($PROGRAM_NAME)
