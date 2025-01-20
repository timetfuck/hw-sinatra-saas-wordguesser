class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses

  MAX_GUESS_TIMES = 7



  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def check_win_or_lose
    if win?
      :win
    elsif lose?
      :lose
    else
      :play
    end
  end

  def win?
    @word.chars.all? { |letter| @guesses.include?(letter) }
  end

  def lose?
    return @wrong_guesses.length >= MAX_GUESS_TIMES
  end

  def word_with_guesses
    displayed = ''
    word.each_char do |letter_word|
      if @guesses.downcase.include?(letter_word.downcase)
        displayed << letter_word
      else
        displayed << '-'
      end
    end
    displayed
  end



  def guess(letter)
    raise ArgumentError if letter.nil? || letter.strip.empty?
    raise ArgumentError unless letter.match?(/[A-Za-z]/)

    word_n = @word.downcase
    letter_n = letter.downcase
    guesses_n = @guesses.downcase
    wrong_guesses_n = @wrong_guesses.downcase
    if word_n.include?(letter_n)
      if guesses_n.include?(letter_n)
        return false
      end
      @guesses << letter
      true
    else
      if wrong_guesses_n.include?(letter_n)
        return false
      end
      @wrong_guesses << letter
      true
    end
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
