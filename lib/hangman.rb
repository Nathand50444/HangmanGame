require 'pry'

class Hangman

    # 1. When a new game is started, your script should load in the dictionary and randomly select...
    # a word between 5 and 12 characters long for the secret word. (Complete)

    # 2. Draw an stick figure as the game goes on and display a count so the player knows how many more... 
    # incorrect guesses they have before the game ends. 
    
    # 3. You should display which CORRECT letters have already been chosen...
    # (and their position in the word, e.g. _ r o g r a _ _ i n g) and which INCORRECT letters have already been chosen.

    # 4. Every turn, allow the player to make a case insensitive guess of a letter. Update the display for correct or incorrect. 
    # If out of guesses, the player should lose.

    # 5. Now implement the functionality where, at the start of any turn, instead of making a guess 
    # the player should also have the option to save the game. 
    # Remember what you learned about serializing objects… you can serialize your game class too!

    # 6. When the program first loads, add in an option that allows you to open one of your saved games... 
    # which should jump you exactly back to where you were when you saved. Play on!
    
    def initialize
        word_bank
        computer_choice
    end

    def word_bank   # Open the .txt file containing the list of words.
        @words = []  # Create an array of words for our computer to guess from.
        contents = File.foreach("google-10000-english.txt") do |line|   # Read the words from the file and store them in an array.
            if line.chomp.length.between?(5, 12)
                @words.append(line.downcase)
            end
        end
    end

    def computer_choice
        chosen_word = @words.sample
        puts "I've chosen a word with #{chosen_word.length} letters! Guess a letter to start the game of Hangman!"
        # Select a random word from the array to be the target word for the game.
        game_board(chosen_word)
    end

    def game_board(chosen_word)
        @board = Array.new(chosen_word.length, "_ ")
        puts @board.join
    end

    def player_guess
        loop do 
            guess = gets.downcase.chomp 
            if guess.length == 1 && guess.match?(/[a-z]/)
                # Feed into 'add_to_board' method TBD
            else
                puts "Please enter only one letter character."
            end
        end
    end

    def add_to_board
    
    end

    def guess_tally

    end
end