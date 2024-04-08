def word_bank   # Open the .txt file containing the list of words.
    words = []  # Create an array of words for our computer to guess from.
    contents = File.each("google-10000-english.txt") do |line| 
        if line.length >= 5
            puts line
            words += line
            binding.pry
        end
        puts words
    end
end