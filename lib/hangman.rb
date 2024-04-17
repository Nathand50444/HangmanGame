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
    # Remember what you learned about serializing objects… you can serialize your game class too!  (COMPLETE)

    # 6. When the program first loads, add in an option that allows you to open one of your saved games... 
    # which should jump you exactly back to where you were when you saved. Play on!  (COMPLETE)
    
    def initialize
        puts "Would you like to start a new game or load a saved game? (new/load)"
        choice = gets.chomp.downcase    

        if choice == "new"                      # Initialize allows the player to select an option to create a 'new' game or 'load' a saved game.
            new_game
        elsif choice == "load"
            load_game
        else
            puts "Invalid choice. Exiting."
            exit
        end
    end


    def new_game
        word_bank                               # Triggers methods required to start the game.
        computer_choice                         # A word bank is created to feed into the computer's word slection.
        initialize_board                        # The chosen_word feeds into the board to select the number of empty spaces.
        game_board                              # The 'turn' method is called to begin the game.
        turn
    end

    def initialize_board
        @board = Array.new(((@chosen_word.length)-1), " _ ")        # The board is set with " _ " elements for each letter in the 'chosen_word'.
    end

    def load_game
        puts "Enter the filename to load:"                           
        filename = gets.chomp

        if File.exist?(filename)                                    # A game is loaded by asking for the save filename.
            data = JSON.parse(File.read(filename))                  # The chose file is parsed with data points attributed to each variable.
            @chosen_word = data['chosen_word']
            @board = data['board']
            @incorrect_guesses = data['incorrect_guesses']
            @tally = data['tally']
            @i_tally = data['i_tally']

            puts "Game loaded successfully!"
            game_board                                              # Using the now attributed data points, the game board is set and a new turn is called.
            turn
        else
            puts "File not found. Please enter a valid filename."   # Rescue if filename is not recognised.
            load_game
        end
    end

    def word_bank                                                       # Open the .txt file containing the list of words.
        @words = []                                                     # Create an array of words for our computer to guess from.
        contents = File.foreach("google-10000-english.txt") do |line|   # Read the words from the file and store them in an array.
            if line.chomp.length.between?(5, 12)                        # All words between 5-12 characters are selected.
                @words.append(line.downcase)                            # Words selected are appended to the 'words' array.
            end
        end
    end

    def computer_choice
        @chosen_word = @words.sample
        puts "I've chosen a word with #{@chosen_word.length} letters! Guess a letter to start the game of Hangman!"
        # Select a random word from the array to be the target word for the game.
    end

    def game_board
        display_board = @board.map { |char| char == " _ " ? " _ " : char }  # For each character in @board a check is performed to create a new array of the board.
        puts display_board.join
    end

    def player_guess
        puts "Guess a letter within the word! (or enter 'save' to save the game)"   # The player can now guess a letter within the 'chosen_word'
        guess = gets.downcase.chomp
        if guess.length == 1 && guess.match?(/[a-z]/)                               # Is the guess one character in length and between the letters a-z?
            if @chosen_word.include?(guess)                                         # Is the guessed letter in the chosen_word?
                add_to_board(guess) 
                guess_tally                                                # If yes, the guess is fed through the 'add_to_board' method.
                puts "Incorrect guesses: #{@incorrect_guesses.join(", ")}"
            else 
                puts "Incorrect."
                @incorrect_guesses.append(guess)                                    # If no, the guess is added to the 'incorrect_guesses' variable to log all incorrect letters.
                puts "Incorrect guesses: #{@incorrect_guesses.join(", ")}"
                incorrect_tally                                                     # A tally of incorrect guesses is made to satisfy the end_game checks.
                guess_tally
                puts @board.join
            end
        elsif guess == "save"                                                       # A save game feature is available.
                save_game
                exit
        else
            puts "Please enter only a one letter character."
        end
    end

    def add_to_board(guess)                                     
        word_array = @chosen_word.chomp.split("")               # The guess is added to the board where necessary by iterating through the 'chosen_word'...
        word_array.each_with_index do |letter, index|           # ...and inputing the letter into @board in the same position.
            if guess == letter
                @board[index] = letter
            end
        end
        puts @board.join                                        
    end
    
    def guess_tally
        @tally += 1     # The game turn is logged for the 'end_game' method.
    end

    def turn
        @incorrect_guesses = []         # When the turn is activated the variable required to log the game are created. 
        @tally = 0                  
        @i_tally = 0
        loop do                         # A loop activates a new turn perpetually and ends when an 'end_game' condition is met.
            player_guess
            guess_tally
            break if end_game?
        end
    end

    def incorrect_tally
        @i_tally += 1   # Incorrect guesses are also logged for the 'end_game'.
    end

    def end_game?
        if !@board.include?(" _ ")                                  # Three conditions to dictate the end_game:
            puts 'Well done! You guessed the word!'                 # The player guesses the word correctly with all letters gussed.
            print "#{@chosen_word}"
            true
        elsif @i_tally == 10                                        # The player has 10 incorrect guesses.
            puts 'Game Over! You had too many incorrect guesses'
            print "The word was #{@chosen_word}"
            true
        elsif @tally == 14                                          # The player takes 14 or more turns to guess.
            puts 'Game Over! You have run out of guesses.'
            print "The word was #{@chosen_word}"
            true
        else
            false
        end
    end

    def save_game                                           
        puts "Enter the filename to save:"                  # The game can be saved by entering a chosen filename.
        filename = gets.chomp

        File.open(filename, 'w') do |file|                  # The method generates JSON file that can be read to load in the game.
            file.write(JSON.generate(self.to_h))
        end
        puts "Game saved successfully as #{filename}!"
    end

    def to_h                                                # to_h dictates how the JSON file is written and what data is allocated where.
        {
            chosen_word: @chosen_word,
            board: @board,
            incorrect_guesses: @incorrect_guesses,
            tally: @tally,
            i_tally: @i_tally
        }
    end
end