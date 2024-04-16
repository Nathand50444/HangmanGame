require 'json'

class Hangman

    # 1. When a new game is started, your script should load in the dictionary and randomly select...
    # a word between 5 and 12 characters long for the secret word. (COMPLETE)

    # 2. Draw a stick figure as the game goes on and display a count so the player knows how many more... 
    # incorrect guesses they have before the game ends. 
    
    # 3. You should display which CORRECT letters have already been chosen...
    # (and their position in the word, e.g. _ r o g r a _ _ i n g) and which INCORRECT letters have already been chosen. (COMPLETE)

    # 4. Every turn, allow the player to make a case insensitive guess of a letter. Update the display for correct or incorrect. 
    # If out of guesses, the player should lose. (COMPLETE)

    # 5. Now implement the functionality where, at the start of any turn, instead of making a guess 
    # the player should also have the option to save the game. 
    # Remember what you learned about serializing objects… you can serialize your game class too!

    # 6. When the program first loads, add in an option that allows you to open one of your saved games... 
    # which should jump you exactly back to where you were when you saved. Play on!
    
    def initialize
        puts "Would you like to start a new game or load a saved game? (new/load)"
        choice = gets.chomp.downcase

        if choice == "new"
            new_game
        elsif choice == "load"
            load_game
        else
            puts "Invalid choice. Exiting."
            exit
        end
    end


    def new_game
        word_bank
        computer_choice
        initialize_board
        game_board
        turn
    end

    def initialize_board
        @board = Array.new(@chosen_word.length, " _ ")
    end

    def load_game
        puts "Enter the filename to load:"
        filename = gets.chomp

        if File.exist?(filename)
            data = JSON.parse(File.read(filename))
            @chosen_word = data['chosen_word']
            @board = data['board']
            @incorrect_guesses = data['incorrect_guesses']
            @tally = data['tally']
            @i_tally = data['i_tally']

            puts "Game loaded successfully!"
            game_board
            turn
        else
            puts "File not found. Please enter a valid filename."
            load_game
        end
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
        @chosen_word = @words.sample
        puts "I've chosen a word with #{@chosen_word.length} letters! Guess a letter to start the game of Hangman!"
        # Select a random word from the array to be the target word for the game.
    end

    def game_board
        display_board = @board.map { |char| char == " _ " ? " _ " : char }
        puts display_board.join
    end

    def player_guess
        puts "Guess a letter within the word! (or enter 'save' to save the game)"
        guess = gets.downcase.chomp
        if guess.length == 1 && guess.match?(/[a-z]/)
            if @chosen_word.include?(guess)
                add_to_board(guess)
                puts "Incorrect guesses: #{@incorrect_guesses.join(", ")}"
            else 
                puts "Incorrect."
                @incorrect_guesses.append(guess)
                puts "Incorrect guesses: #{@incorrect_guesses.join(", ")}"
                incorrect_tally
                guess_tally
                puts @board.join
            end
        elsif guess == "save"
                save_game("saved_game.json")
                exit
        else
            puts "Please enter only a one letter character."
        end
    end

    def add_to_board(guess)
        word_array = @chosen_word.chomp.split("")
        word_array.each_with_index do |letter, index|
            if guess == letter
                @board[index] = letter
            end
        end
        puts @board.join
    end
    
    def guess_tally
        @tally += 1
    end

    def turn
        @incorrect_guesses = []
        @tally = 0
        @i_tally = 0
        loop do 
            player_guess
            guess_tally
            break if end_game?
        end
    end

    def incorrect_tally
        @i_tally += 1
    end

    def end_game?
        if !@board.include?(" _ ")
            puts 'Well done! You guessed the word!'
            print "#{@chosen_word}"
            true
        elsif @i_tally == 10
            puts 'Game Over! You had too many incorrect guesses'
            print "The word was #{@chosen_word}"
            true
        elsif @tally == 14 
            puts 'Game Over! You have run out of guesses.'
            print "The word was #{@chosen_word}"
            true
        else
            false
        end
    end

    def save_game(filename)
        File.open(filename, 'w') do |file|
            file.write(JSON.generate(self.to_h))
        end
        puts "Game saved successfully as #{filename}!"
    end

    def to_h
        {
            chosen_word: @chosen_word,
            board: @board,
            incorrect_guesses: @incorrect_guesses,
            tally: @tally,
            i_tally: @i_tally
        }
    end
end