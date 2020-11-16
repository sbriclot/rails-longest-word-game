require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    vowels = ["A", "E", "I", "O", "U"]
    @letters = [];
    7.times { @letters << alphabet.sample }
    3.times { @letters << vowels.sample }
    @letters.shuffle
  end

  def score
    @proposal = params[:proposal].upcase
    ary_letters = params[:letters].split
    @letters = ary_letters.join(", ")
    @use_grid_only =  use_grid_letters?(ary_letters, @proposal)
    @valid_word = word_in_dictionnary?(@proposal)
    if @valid_word
      @points = @proposal.length
      save_score(get_score + @points)
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
    return JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@proposal}").read)["found"]
  end
end
