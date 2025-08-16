require_relative '../config/constants'

class GameState
  attr_reader :word_to_guess, :guessed_so_far

  def initialize(word_to_guess)
    @word_to_guess = word_to_guess
    @guessed_so_far = '_' * word_to_guess.length
    @incorrect_letters = []
    @mistakes = 0
  end

  def update_state(char)
    if word_to_guess.include?(char)
      word_to_guess.chars.each_with_index do |solution_char, index|
        @guessed_so_far[index] = char if solution_char == char
      end
    elsif incorrect_letters.include?(char)
      @mistakes += 2
    else
      @incorrect_letters << char
      @mistakes += 1
    end
  end

  def incorrect_letters
    @incorrect_letters.join(' ')
  end

  def mistakes
    "#{@mistakes}/#{Constants::ATTEMPTS}"
  end

  def game_over?
    loser? || winner?
  end

  def winner?
    @guessed_so_far == @word_to_guess
  end

  def loser?
    @mistakes >= Constants::ATTEMPTS
  end
end
