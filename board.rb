class Board
  attr_accessor :grid

  SYMBOLS = ["😀", "🐢", "🐝", "🍆", "🍭", "🎱", "📺", "🌀"]

  def initialize(grid = Array.new(4) { Array.new(4) })
    @grid = grid
  end

  def self.random
    board = Board.new
    board.populate
    board
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, arg)
    @grid[row][col] = arg
  end

  def populate
    cards = make_deck.shuffle
    @grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        self[row_idx, col_idx] = cards.pop
      end
    end
  end

  def render
    @grid.each do |row|
      line = []
      row.each { |card| line << card.to_s }
      puts line.join(" ")
      puts
    end
  end

  def won?
    @grid.all? do |row|
      row.all? { |card| card.state == :face_up }
    end
  end

  def reveal(guessed_pos)
    self[*guessed_pos].reveal
  end

  def hide(guessed_pos)
    self[*guessed_pos].hide
  end

  def reveal_all
    @grid.each_with_index do |row, row_idx|
      row.each_index { |col_idx| reveal([row_idx, col_idx]) }
    end
  end

  def make_deck
    deck = []
    SYMBOLS.each do |symbol|
      2.times { deck << Card.new(symbol) }
    end
    deck
  end
end
