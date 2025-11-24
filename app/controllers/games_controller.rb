require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("a".."z").to_a.sample }
  end

  def score
    @score_total = 0
    @player_word = params[:word]
    @player_word_letters = @player_word.downcase.chars
    @letter_grid = params[:letters].split("")
    temp_grid = @letter_grid.dup

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
