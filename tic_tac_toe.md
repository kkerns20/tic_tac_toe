# Tic_Tac_Toe Bonus Features

## Improved "join"

### Problem

The prompt for join can be improved. If we separated it with a delimiter an conjunction, it would read a lot more smoothly. Instead of the built in `join` method, I want to create a `joinor` method with some of these specifications:

- Input: three arguments, an array and two (optional) strings
  - array will represent the elements to join into a string
  - first string argument is optional delimiter (comma)
  - second string argument is conjunction before last element
- Output: a single string that list everything passed into it
  - Grammar needs to be on point
    - if only two elements, no delimiter needed
  - If no argument for delimiter, then use `', '` as default
  - If no argument for conjunction, then use `'or '` as default
  - If array passed as argument is empty, return empty string
  - If array passed as argument has one element, return that  single element as a string

### Examples / Test Cases

```ruby
joinor([1, 2])                   # => "1 or 2"
joinor([1, 2, 3])                # => "1, 2, or 3"
joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
```
### Algorithm / Data structure

1. Analyze size of array
2. Empty?
    - Return empty string
3. If it has one element:
    - Return that element as string
4. If it has two elements:
    - Return the element at index 0 + space + conjunction + space + element at index 1
5. If it has more that 2 elements:
    - Join all the array elements exept the last one with the provided delimiter
    - Append punctuation + conjunction + last array element to the string
6. Return the string

## Keeping Score

### Problem

Keep score of how many games each player wins, with first to 5 wins is the overall winner

### Rules

- Don't use global or instance variables.
- First player to 5 wins is grand champion, display winner
- Add explanation of game rules and first-to-five rule to welcome
- display a running total of each players score when scoreboard is displayed

### Algorithm / Data structure

1. Add to `display_welcome` message explaining the rules for the tourney 
2. Create an outer loop around main `play_game` loop
    - Possibly separate method `play_tournament`
3. Initialize hash outside of main `play_game` loop to keep track of players scores
4. Make sure hash is passed in as an argument to relevant methods
5. No matter who wins, update scores hash (like rpslk)
    - Display the updated score for winner
    - Use the sleep on the `prompt` method for increased readability, like Ginny did, before screen is cleared. name it `prompt_pause`
6. Display the running score with the board display on each turn / play_through
7. If either player gets 5 wins, end `play_tournament` loop
    - method to return a Boolean, ask to `play_tourney_again?`
8. Display message for the `grand_champion`
9. Ask player if the want to play again outside of `play_game` loop that is also break condition for outside `play_tournament` loop
 
## Computer AI: Defense

### Problem

Right now, the computer picks at random and is easily beatable. No fun, so let's make the computer defensive-minded, like immediately filling an at risk spot. Outside of that, the `sample` method will suffice.

### Rules

1. If 2 squares are marked by the player in a winning row, the computer should mark the last square
2. Otherwise, `sample` will suffice.

### Algorithm / Data Structure

1. Assign `square` to the value of `nil`. Now it can be used in a conditional to see if another value has been assigned in the `defensive` iteration.
2. Iterate through the `WINNING_LINES constant
3. Within each iteration, assign the value (if any) returned by `defensive_computer_move` to `square`
4. Within `defensive_computer_move` method:
    - If any of the winning lines contain 2 of hte opponent's markers and 1 of the initial marker
    - Return the element in the current `line` whose value is `INITIAL_MARKER`
    - If there is no defensive moves available, the `if` statement will return `nil` which will be assigned to `square` again
5. Break out of the iterations through `WINNING_LINES` if `square` is assigned to a truthy value
6. If `square` still references `nil`, then assign to a random square as in walkthrough
7. Mutate the `board` hash to reflect the computer's move, no matter how the defense worked out.

## Computer AI: Offense

### Problem

Playing defense is great, buts its the entirety of the game that is fun. So, let's give the computer some offensive capabilities as well. If the computer has 2 squares in a row filled, then go ahead and win the gah dog game. (*Good lord I'm getting tired of writing all of this from the suggestions -- power through*)

### Rules

1. First the computer will check to see if it needs to be defensively minded.
2. The the computer should check to see if it has an offensive opportunity
    - If two of the squares on `WINNING_ROWS` are filled, finish the job
3. Otherwise, after checking defense and offense, `sample` will suffice.

### Algorithm / Data Strucure

1. First check to see if there are any [Defensive Moves](#Computer-AI:-Defense)
2. Iterate through the `WINNING_LINES` constant
    - Within each iteration, assign the value (if any) returned by `offensive_computer_move` to `square`
      - if any of th winning lines contain 2 of the computer's marker and 1 of the initial marker:
        - Return the element in the current `line` whose value is `INITIAL_MARKER`
        - if no offensive moves are available, the `if` statement will return `nil` which will keep square to a falsey value
    - Break out of the iterations through `WINNING_LINES` if `square` is assigned a truthy value
3. If `square` still references `nil` then assign a random square
4. Mutate the `board` hash to reflect the computer's move

## Computer Turn Refinements

### Rules

1. We actually have the offense and defense steps backwards. In other words, if the computer has a chance to win, it should take that move rather than defend. 
2. We can make one more improvement: pick square #5 if it's available. The AI for the computer should go like this: 
    - pick the winning move; 
    - defend if opponent can win; 
    - pick square #5; 
    - pick a random square.
3. Create a constant such that the game can be played with either player going first. The player can choose whether the player, computer, or defer to computer to choose
4. Improve game loop to take away some redundancy

### Pick Square # 5

  - Add conditional within the `if !square` statement
  - If square $5 is still empty ( if the value is the `INITIAL_MARKER)
  - `square` will be equal to `5`
  - Otherwise, allow the computer to choose randomly

### Who is gonna go first?

  - Create a constant `FIRST_TURN = { current_player: 'choose' }
  - In another method, prompt the user to choose who will go first, `'Player'` or `'Computer'`
      - Have 'p' = PLAER and 'c' = COMPUTER
      - validate input
      - Modify `FIRST_TURN` hash according to the user's choice
  - In the `turn_cycle` method definition:
      - If `FIRST_TURN[:current_player] == PLAYER`, game continues as before
      - If `FIRST_TURN[:current_player] == COMPUTER`:
          - New method `determine_turn`
          - Would that mean computer places piece before? (Duh)
    - Switch to `alternate_player` when starting new match
  - If starting a new tournament, reset `FIRST_TURN[:current_player]` to `'Choose'`

## Improving the game loop

```ruby
loop do
  display_board(board)
  place_piece!(board, current_player)
  current_player = alternate_player(current_player)
  break if someone_won?(board) || board_full?(board)
end
  ```
### Algorithm

- `place_piece!` method
  - If `current_player == PLAYER` then invoke `player_places_piece!`
  - If `current_player == COMPUTER` then invoke `computer_places_piece!`
- `alternate_player`
  - If `current_player == PLAYER` then set it to `COMPUTER`
  - If `current_player == COMPUTER` then set it to `PLAYER`

## Other Improvement To-Dos

- [] Extract all instances of the strings "Player" & "Computer" to constants
- [] Print the square numbers when the board is displayed
- [] Go through and make sure all methods are discreet and simple (i.e. side-effect or return value? not both)
- [] Organize method definitions for easy code readability
- [] Better input validation throughout
- [] Get rid of any code redundancies
- [] Extract hard-coded `5` (games to win tournament) to constant (`tournament_over?`)
- [] Add "Would you like to keep playing?" after each game to make it easy to quit out before tournament completion
 