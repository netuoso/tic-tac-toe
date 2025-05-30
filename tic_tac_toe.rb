class TicTacToe
  HUMAN = 'X'
  COMPUTER = 'O'
  EMPTY = ' '

  attr_reader :board

  def initialize
    @board = Array.new(9, EMPTY)
  end

  def board_state
    @board.dup
  end

  def valid_move?(pos)
    pos.between?(0, 8) && @board[pos] == EMPTY
  end

  def make_human_move(pos)
    @board[pos] = HUMAN if valid_move?(pos)
  end

  def make_computer_move
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

  def game_over?
    winner || board_full?
  end

  def outcome_message
    case winner
    when HUMAN
      "You win! 😮"
    when COMPUTER
      "Computer wins! 🤖"
    else
      "It's a draw! 🤝"
    end
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

  def score(result)
    return 1 if result == COMPUTER
    return -1 if result == HUMAN
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