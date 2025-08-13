require_relative 'config/constants'

def get_random_word(sourcefile, minlength, maxlength)
  wordlist = []
  File.readlines(sourcefile).each do |line|
    word = line.chomp
    wordlist << word if word.length.between?(minlength, maxlength)
  end
  wordlist.sample
end

def save
  puts 'SAVING GAME...'
  Kernel.exit(0)
end

word_to_guess = get_random_word(Constants::SOURCEFILE, Constants::MINLENGTH, Constants::MAXLENGTH)
guessed = '_' * word_to_guess.length
incorrect_letters = []
mistakes = 0

puts 'HANGMAN - try to guess the word!'

while mistakes < Constants::ATTEMPTS && guessed != word_to_guess
  puts "\tMISTAKES #{mistakes}/#{Constants::ATTEMPTS}"
  puts "\tINCORRECT LETTERS SO FAR: #{incorrect_letters.join(' ')}"
  puts "\t#{guessed}"
  input = gets.downcase.chomp
  save if input == 'save'
  char = input[0]
  if word_to_guess.include?(char)
    word_to_guess.chars.each_with_index do |solution_char, index|
      guessed[index] = char if solution_char == char
    end
  else
    incorrect_letters << char
    mistakes += 1
  end
end

verb = mistakes == Constants::ATTEMPTS ? 'LOSE' : 'WIN'

puts "\nTHE WORD WAS #{word_to_guess}, YOU #{verb}"
