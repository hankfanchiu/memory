require_relative "card"
require_relative "board"
require_relative "player"

class Game
  WAIT_TIME = 1

  def initialize(player, board = Board.random)
    @player = player
    @board = board
    @board_rows = @board.grid.size
    @board_cols = @board.grid.first.size
  end

  def play
    until over?
      clear_and_render
      play_turn
    end
    puts "Game over!"
  end

  def play_turn
    guess1 = prompt_guess(1)
    reveal_card(guess1)
    pass_revealed_card(guess1)
    clear_and_render

    guess2 = prompt_guess(2)
    reveal_card(guess2)
    pass_revealed_card(guess2)
    clear_and_render

    if match?(guess1, guess2)
      pass_match(guess1, guess2)
      puts "The cards matched!"
    else
      hide_guesses(guess1, guess2)
      puts "The cards didn't match."
    end
    sleep(WAIT_TIME)
  end

  def prompt_guess(attempt)
    @player.prompt(attempt)
    guess = @player.get_input(@board_rows, @board_cols)
    while revealed?(guess)
      print "That card is already facing up. Guess again: "
      guess = @player.get_input(@board_rows, @board_cols)
    end
    guess
  end

  def revealed?(guess)
    @board[*guess].state == :face_up
  end

  def reveal_card(guess)
    @board.reveal(guess)
  end

  def pass_revealed_card(guess)
    revealed_card = @board[*guess].face_value
    @player.receive_revealed_card(guess, revealed_card)
  end

  def pass_match(guess1, guess2)
    @player.receive_match(guess1, guess2)
  end

  def match?(card1, card2)
    @board[*card1].face_value == @board[*card2].face_value
  end

  def hide_guesses(card1, card2)
    @board.hide(card1)
    @board.hide(card2)
  end

  def clear_and_render
    system("clear")
    @board.render
  end

  def over?
    @board.won?
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Enter human player name, or press enter:"
  name = gets.chomp
  player = name.empty? ? ComputerPlayer.new : HumanPlayer.new(name)

  Game.new(player).play
end
