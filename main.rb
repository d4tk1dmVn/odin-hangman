require_relative 'config/constants'
require_relative 'lib/gamestate'

def get_random_word(sourcefile, minlength, maxlength)
  wordlist = []
  File.readlines(sourcefile).each do |line|
    word = line.chomp
    wordlist << word if word.length.between?(minlength, maxlength)
  end
  wordlist.sample
end

def write_file(gamestate, destination)
  serialized_gamestate = Marshal.dump(gamestate)
  f = File.open(destination, 'w')
  f.puts serialized_gamestate
  f.close
end

def read_file(sourcefile)
  result = ''
  File.readlines(sourcefile).each { |line| result << line }
  Marshal.load(result)
end

def save
  puts 'WHERE SHALL WE SAVE THE GAME?'
  input = gets.chomp
  input = gets.chomp while File.exist?(input)
  write_file(gamestate, input)
  puts "\e[H\e[2J"
  puts "GAME SAVED AT FILE #{input}"
  puts "\nExiting...\n"
  Kernel.exit(0)
end

def load
  puts 'WHICH IS THE SAVED GAME NAME?'
  input = ''
  input = gets.chomp until File.exist?(input)
  read_file(input)
end

def new_game
  word_to_guess = get_random_word(Constants::SOURCEFILE, Constants::MINLENGTH, Constants::MAXLENGTH)
  GameState.new(word_to_guess)
end

def game_loop(gamestate)
  puts "\tMISTAKES #{gamestate.mistakes}"
  puts "\tINCORRECT LETTERS SO FAR: #{gamestate.incorrect_letters}"
  puts "\t#{gamestate.guessed_so_far}"
  input = gets.downcase.chomp
  save(gamestate) if input == 'save'
  char = input[0]
  gamestate.update_state(char)
end

def play_game
  puts "\e[H\e[2J"
  puts 'HANGMAN - try to guess the word!'
  puts 'WOULD YOU LIKE TO LOAD A GAME?'
  input = ''
  input = gets.chomp until %w[y n].include?(input)
  gamestate = input == 'y' ? load : new_game
  game_loop(gamestate) until gamestate.game_over?
  verb = gamestate.loser? ? 'LOSE' : 'WIN'
  puts "\nTHE WORD WAS #{gamestate.word_to_guess}, YOU #{verb}"
end

play_game
