# ttt_bonus.rb
# Bonus Features

require 'yaml'
MESSAGES = YAML.load_file('ttt_bonus_messages.yml')

PLAYER = 'Player'
COMPUTER = 'Computer'
YES_OR_NO = %w(y n yes no)

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

TOURNAMENT_GAMES = 5
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt_pause(action)
  puts ">> #{MESSAGES[action]}"
  sleep(1.5)
end

def prompt(msg)
  puts ">> #{msg}"
end

def clear_screen
  system 'clear'
end

def valid_input
  answer = nil

  loop do
    answer = gets.chomp.downcase.strip
    break if YES_OR_NO.include?(answer)
    prompt_pause(:invalid)
  end

  answer == 'y' || answer == 'yes' ? 'y' : 'n'
end

def quit_game
  display_goodbye
  exit
end

def display_welcome
  clear_screen
  prompt_pause(:welcome)
  prompt_pause(:goal)
  prompt_pause(:way_to_win)
  prompt_pause(:end_goal)
  prompt_pause(:begin)
  answer = valid_input
  quit_game if answer == 'n'
end

def display_goodbye
  prompt_pause(:thank_you)
  prompt_pause(:quote)
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd, score)
  clear_screen
  puts "You are #{PLAYER_MARKER}, the Computer is #{COMPUTER_MARKER}."
  puts <<~MSG
              -------------------------------------
              SCOREBOARD: #{PLAYER}: [#{score[PLAYER]}] #{COMPUTER}: [#{score[COMPUTER]}]
              -------------------------------------
  MSG
  puts ""
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def decide_first_turn
  answer = nil

  loop do
    prompt_pause(:decide_first_turn)
    answer = gets.chomp.downcase
    break if ['p', 'c'].include?(answer)
    prompt_pause(:invalid)
  end

  answer == 'p' ? PLAYER : COMPUTER
end

def alternate_first_turn(first_turn)
  first_turn == PLAYER ? COMPUTER : PLAYER
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(array, delimiter = ', ', conjunction = 'or')
  case array.size
  when 0 then ''
  when 1 then array[0].to_s
  when 2 then "#{array[0]} #{conjunction} #{array[1]}"
  else
    array[0..-2].join(delimiter) +
      "#{delimiter}#{conjunction} #{array[-1]}"
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp
    if empty_squares(brd).include?(square.to_i) && square.to_i.to_s == square
      break
    else
      prompt_pause(:invalid)
    end
  end

  brd[square.to_i] = PLAYER_MARKER
end

# def computer_places_piece!(brd) # Couldn't get this to work-might debug
#   find_at_risk_square(brd, COMPUTER_MARKER) ||
#   find_at_risk_square(brd, PLAYER_MARKER) ||
#   center_square(brd) ||
#   corner_play(brd) ||
#   empty_squares(brd).sample
# end

# def find_at_risk_square(brd, marker)
#   WINNING_LINES.each do |line|
#     line_board_values = brd.values_at(*line)
#     if line_board_values.count(marker) == 2 &&
#        line_board_values.include?(INITIAL_MARKER)
#       return brd.select { |k, _| line.include?(k) }.key(INITIAL_MARKER)
#     end
#   end
#   nil
# end

def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    break if square
    square = smart_computer_moves(line, brd, COMPUTER_MARKER)
  end

  WINNING_LINES.each do |line|
    break if square
    square = smart_computer_moves(line, brd, PLAYER_MARKER)
  end

  if !square
    square = center_corner_random(brd)
  end

  brd[square] = COMPUTER_MARKER
end

def smart_computer_moves(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2 &&
     brd.values_at(*line).count(INITIAL_MARKER) == 1
    line.find { |sq| brd[sq] == INITIAL_MARKER }
  end
end

def center_corner_random(brd)
  if brd[5] == INITIAL_MARKER
    5
  elsif brd[5] == PLAYER_MARKER ||
        brd[5] == COMPUTER_MARKER
    corner_play(brd)
  else
    empty_squares(brd).sample
  end
end

def corner_play(brd)
  if brd.values_at(1, 9).all?(PLAYER_MARKER) ||
     brd.values_at(3, 7).all?(PLAYER_MARKER)
    brd.slice(2, 4, 6, 8).key(INITIAL_MARKER)
  elsif brd.values_at(1, 3).all?(PLAYER_MARKER) || # I can't win with this
        brd.values_at(3, 9).all?(PLAYER_MARKER) ||
        brd.values_at(1, 7).all?(PLAYER_MARKER) ||
        brd.values_at(7, 9).all?(PLAYER_MARKER)
    brd.slice(2, 4, 6, 8).key(INITIAL_MARKER)
  else
    brd.slice(1, 3, 7, 9).key(INITIAL_MARKER)
  end
end

def place_piece!(brd, player)
  player_places_piece!(brd) if player == PLAYER
  computer_places_piece!(brd) if player == COMPUTER
end

def alternate_player(player)
  return COMPUTER if player == PLAYER
  return PLAYER if player == COMPUTER
end

def turn_cycle(brd, score, first_turn)
  current_player = first_turn

  loop do
    display_board(brd, score)
    place_piece!(brd, current_player)
    # binding.pry
    current_player = alternate_player(current_player)
    break if someone_won?(brd) || tie?(brd) || board_full?(brd)
  end

  display_board(brd, score)
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def tie?(brd)
  empty_squares(brd).size == 1
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return PLAYER
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return COMPUTER
    end
  end

  nil
end

def update_scoreboard!(brd, score)
  score[detect_winner(brd)] += 1
end

def game_over(brd, score)
  if someone_won?(brd)
    update_scoreboard!(brd, score)
    prompt "#{detect_winner(brd)} won!"
  else
    prompt_pause(:tie)
  end
  puts <<~MSG
              -------------------------------------
              SCOREBOARD: #{PLAYER}: [#{score[PLAYER]}] #{COMPUTER}: [#{score[COMPUTER]}]
              -------------------------------------
  MSG
end

def play_game(score, first_turn)
  loop do
    brd = initialize_board

    turn_cycle(brd, score, first_turn)
    game_over(brd, score)
    keep_playing? unless tournament_over?(score)

    first_turn = alternate_player(first_turn)

    break if tournament_over?(score)
  end
end

def keep_playing?
  prompt_pause(:keep_playing)
  answer = valid_input
  quit_game if answer == 'n'
end

def tournament_over?(score)
  score[PLAYER] >= TOURNAMENT_GAMES ||
    score[COMPUTER] >= TOURNAMENT_GAMES
end

def play_tournament
  loop do
    score = { PLAYER => 0, COMPUTER => 0 }
    first_turn = decide_first_turn

    play_game(score, first_turn)
    display_tourney_winner(score)

    prompt_pause(:keep_playing)
    answer = valid_input

    break if answer == 'n'
  end
end

def display_tourney_winner(score)
  clear_screen
  puts ''
  if scores[PLAYER] < score[COMPUTER]
    prompt_pause(:computer_won)
    prompt_pause(:kidding)
  else
    prompt_pause(:player_won)
  end
  puts ''
end

display_welcome
play_tournament
display_goodbye
