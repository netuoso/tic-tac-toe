class TicTacToe
  HUMAN = 'X'
  COMPUTER = 'O'
  EMPTY = ' '

  def initialize
    @board = Array.new(9, EMPTY)
  end

  def play
    puts "Welcome to Unbeatable Tic Tac Toe!"
    puts "You are #{HUMAN}, computer is #{COMPUTER}."
    puts "Enter positions as numbers 1-9:"
    # puts_board_guide
    current_player = HUMAN

    loop do
      display_board

      if current_player == HUMAN
        human_move
        break if game_over?
        current_player = COMPUTER
      else
        puts "Computer is thinking..."
        computer_move
        break if game_over?
        current_player = HUMAN
      end
    end

    display_board
    outcome
  end

  def puts_board_guide
    puts <<~GUIDE
      1 | 2 | 3
     ---+---+---
      4 | 5 | 6
     ---+---+---
      7 | 8 | 9
    GUIDE
    puts "\n\n"
  end

  def display_board
    board_cells = @board.map.with_index { |val, idx| val == EMPTY ? (idx + 1).to_s : val }
    puts <<~BOARD
      #{board_cells[0]} | #{board_cells[1]} | #{board_cells[2]}
     ---+---+---
      #{board_cells[3]} | #{board_cells[4]} | #{board_cells[5]}
     ---+---+---
      #{board_cells[6]} | #{board_cells[7]} | #{board_cells[8]}
    BOARD
    puts "\n\n"
  end

  def human_move
    loop do
      print "Your move (1-9): "
      input = gets.chomp
      pos = input.to_i - 1
      if valid_move?(pos)
        @board[pos] = HUMAN
        break
      else
        puts "Invalid move. Try again."
      end
    end
  end

  def valid_move?(pos)
    pos >= 0 && pos <= 8 && @board[pos] == EMPTY
  end

  def game_over?
    winner || board_full?
  end

  def winner
    winning_combinations.each do |combo|
      if combo.all? { |i| @board[i] == HUMAN }
        return HUMAN
      elsif combo.all? { |i| @board[i] == COMPUTER }
        return COMPUTER
      end
    end
    nil
  end

  def board_full?
    !@board.include?(EMPTY)
  end

  def outcome
    case winner
    when HUMAN
      puts "You win! 😮 (How?)"
    when COMPUTER
      puts "Computer wins! 🤖"
    else
      puts "It's a draw! 🤝"
    end
  end

  def computer_move
    best_score = -Float::INFINITY
    best_move = nil

    available_moves.each do |move|
      @board[move] = COMPUTER
      score = minimax(@board, false)
      @board[move] = EMPTY

      if score > best_score
        best_score = score
        best_move = move
      end
    end

    @board[best_move] = COMPUTER
  end

  def minimax(board, is_maximizing)
    result = winner
    return score(result) if result || board_full?

    if is_maximizing
      max_eval = -Float::INFINITY
      available_moves.each do |move|
        board[move] = COMPUTER
        eval = minimax(board, false)
        board[move] = EMPTY
        max_eval = [max_eval, eval].max
      end
      max_eval
    else
      min_eval = Float::INFINITY
      available_moves.each do |move|
        board[move] = HUMAN
        eval = minimax(board, true)
        board[move] = EMPTY
        min_eval = [min_eval, eval].min
      end
      min_eval
    end
  end

  def score(winner)
    return 1 if winner == COMPUTER
    return -1 if winner == HUMAN
    0
  end

  def available_moves
    @board.each_index.select { |i| @board[i] == EMPTY }
  end

  def winning_combinations
    [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
    ]
  end
end

if __FILE__ == $0
  game = TicTacToe.new
  game.play
end