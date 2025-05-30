require 'sinatra'
require 'json'
require './tic_tac_toe'

enable :sessions

# Helper: Start a new game
def new_game
  session[:game] = TicTacToe.new
end

# Helper: Get current game
def current_game
  session[:game] ||= TicTacToe.new
end

# Route: Serve static index.html from /public automatically
get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

# Route: Start a new game
get '/new_game' do
  content_type :json
  new_game
  {
    board: session[:game].board_state,
    message: "Your move!"
  }.to_json
end

# Route: Human plays a move
post '/play_move' do
  content_type :json
  request_payload = JSON.parse(request.body.read)
  position = request_payload["position"].to_i
  game = current_game

  # Handle special computer-move continuation request
  if position == -1
    if game.game_over?
      return {
        board: game.board_state,
        message: game.outcome_message,
        game_over: true
      }.to_json
    end

    game.make_computer_move

    return {
      board: game.board_state,
      message: game.game_over? ? game.outcome_message : "Your move!",
      game_over: game.game_over?
    }.to_json
  end

  # Regular player move
  unless game.valid_move?(position)
    return {
      board: game.board_state,
      message: "Invalid move. Try again.",
      game_over: false
    }.to_json
  end

  game.make_human_move(position)

  if game.game_over?
    return {
      board: game.board_state,
      message: game.outcome_message,
      game_over: true
    }.to_json
  end

  {
    board: game.board_state,
    message: "Computer is thinking...",
    game_over: false
  }.to_json
end