require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("a".."z").to_a.sample }
  end

  def score
    @score_total = 0 # To allow for displaying a score total
    @player_word = params[:word] # Capturing the word from the form input
    @player_word_letters = @player_word.downcase.chars # Create an array of lowercase letters from the players word
    @letter_grid = params[:letters].split("") # Create an array (from passed string) of the letters the player had to pick from
    temp_grid = @letter_grid.dup # Create a temporary duplicate array to remove from to avoid re-using letters

    valid_word = @player_word_letters.all? do |letter|
      if temp_grid.include?(letter)
        temp_grid.delete_at(temp_grid.index(letter))
        true
      else
        false
      end
    end

    url = "https://dictionary.lewagon.com/#{@player_word}"
    serialized = URI.open(url).read
    result = JSON.parse(serialized)

      if !valid_word
        @player_score = "Sorry! This word cannot be built from the grid!"
      elsif !result["found"]
        @player_score = "Sorry! This word is not a recognised English word!"
      else
        @player_score = "Great work! That is a valid word of #{result["length"]} characters!"
        @score_total += result["length"].to_i
      end
  end
end
