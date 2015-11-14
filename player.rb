class HumanPlayer
  def initialize(name = "human")
    @name = name
  end

  def prompt(arg)
    if arg == 1
      puts "First guess:"
    else
      puts "Second guess:"
    end
  end

  def get_input(board_rows, board_cols)
    guess = gets.chomp
    until valid_input?(guess, board_rows, board_cols)
      puts "Please enter a valid guess."
      guess = gets.chomp
    end

    guess.split(", ").map(&:to_i)
  end

  def valid_input?(guess, r, c)
    m = guess.match(/\A([0-9]+), ([0-9]+)\z/)
    if m && (0..r).include?(m[1].to_i) && (0..c).include?(m[2].to_i)
      return true
    end

    false
  end

  def receive_revealed_card(*args)
  end

  def receive_match(*args)
  end
end

class ComputerPlayer
  def initialize(name = "Hal")
    @name = name
    @board = nil
    @previous_guess = nil
  end

  def prompt(arg)
    puts "Press Enter to continue."
    gets
  end

  def get_input(board_rows, board_cols)
    default_board(board_rows, board_cols) if @board.nil?

    found_symbols = Hash.new { |hash, key| hash[key] = [] }
    @board.each_with_index do |row, row_idx|
      row.each_with_index do |card, col_idx|
        position = [row_idx, col_idx]

        next if card == :matched

        if card.nil?
          if @previous_guess
            @previous_guess = nil
          else
            @previous_guess = position
          end
          return position
        end

        if found_symbols[card].size == 1
          first_card_position = found_symbols[card].first
          if @previous_guess
            @previous_guess = nil
            return first_card_position
          else
            @previous_guess = position
            return position
          end
        else
          found_symbols[card] += [position]
        end
      end
    end
  end

  def receive_revealed_card(position, face_value)
    row, col = position
    @board[row][col] = face_value
  end

  def receive_match(l1, l2)
    @board[l1[0]][l1[1]] = :matched
    @board[l2[0]][l2[1]] = :matched
  end

  def default_board(board_rows, board_cols)
    @board = Array.new(board_rows) { Array.new(board_cols) }
  end
end
