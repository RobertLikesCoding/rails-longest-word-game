require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # @word =

  def new
    alphabet = ("A".."Z").to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @letters = params[:letters]
    @user_input = params[:word].upcase
    letters_exist = @user_input.upcase.split(//).all? { |letter| @letters.include?(letter) }

    if letters_exist
      uri_response = URI.open("https://dictionary.lewagon.com/#{@user_input}").read
      parsed_response = JSON.parse(uri_response)
      @word_found = parsed_response[:found]
    end

  end

  private

  def word_in_grid?(user_input, letters)
    user_input.chars.all? { |char| letters.include?(char) }
  end

  def char_usage_ok?(attempt, grid)
    parameter = true
    attempt.upcase.chars.each do |char|
      char_count = attempt.upcase.count(char)
      grid_count = grid.count(char)
      parameter = false if char_count > grid_count
    end
    parameter
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary_serialized = URI.open(url).read
    JSON.parse(dictionary_serialized)["found"]
  end
end
