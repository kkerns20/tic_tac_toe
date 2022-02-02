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
    - Possibly separate method `tournament_style`
3. Initialize hash outside of main `play_game` loop to keep track of players scores
4. Make sure hash is passed in as an argument to relevant methods
5. No matter who wins, update scores hash (like rpslk)
    - Display the updated score for winner
    - Use the sleep on the `prompt` method for increased readability, like Ginny did, before screen is cleared. name it `prompt_pause`
6. Display the running score with the board display on each turn / play_through
7. If either player gets 5 wins, end `tournament_style` loop
    - method to return a Boolean, ask to `play_tourney_again?`
8. Display message for the `grand_champion`
9. Ask player if the want to play again outside of `play_game` loop that is also break condition for outside `tournament_style` loop
 