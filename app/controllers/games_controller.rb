require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = [];
    10.times { @letters << alphabet.sample }
  end

  def score
    @proposal = params[:proposal].upcase
    ary_letters = params[:letters].split
    @letters = ary_letters.join(", ")
    unless use_grid_letters?(ary_letters, @proposal)
      @result = "NotInLetters"
    else
      @result = word_in_dictionnary?(@proposal)
      if @result == "Win"
        @points = @proposal.length
        save_score(get_score + @points)
      end
    end
    @total_score = get_score
    
  end
  
  private

  def use_grid_letters?(letters, proposal)
    proposal.upcase.split("") do |letter|
      index = letters.index(letter)
      return false unless index
  
      letters.delete_at(index)
    end
    true
  end

  def word_in_dictionnary?(proposal)
    if JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@proposal}").read)["found"]
      return "Win"
    else
      return "InvalidWord"
    end
  end
end
