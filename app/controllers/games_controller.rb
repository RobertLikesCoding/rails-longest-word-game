require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @letters = params[:letters]
    @user_input = params[:word].upcase

    if word_in_grid?(@user_input, @letters) && user_input.length < 10 && english_word?(@user_input)
      @result = "<p><strong>Congratulations!</strong> #{@user_input} is a valid word!</p>"
    else
      @result = "<p>Sorry but <strong>#{@user_input}</strong> can't be built out of #{@letters.join(', ')}</p>"
    end

  end

  private

  def word_in_grid?(user_input, letters)
    user_input.chars.all? { |char| letters.include?(char) }
  end

  def english_word?(attempt)
    uri_response = URI.open("https://dictionary.lewagon.com/#{@user_input}").read
    parsed_response = JSON.parse(uri_response)
    @word_found = parsed_response["found"]
  end
end
