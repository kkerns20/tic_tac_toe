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


WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt_pause(action, info='', punctuation='')
  puts ">> #{MESSAGES[action]}"
  sleep(1.5)
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
  quit_game if answer = 'n'
end

def display_goodbye
  prompt_pause(:thank_you)
  prompt_pause(:quote)
end

# rubocop:disable MEtric/AbcSize, Metrics/MethodLength
def display_board(brd, score)
  clear_screen
  puts "You are #{PLAYER_MARKER}, the Computer is #{COMPUTER_MARKER}."
  puts <<~MSG
              -------------------------------------
              SCORE: PLAYER: [#{score[PLAYER]}] COMPUTER: [#{score[COMPUTER]}]
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
# rubocop:enable MEtric/AbcSize, Metrics/MethodLength