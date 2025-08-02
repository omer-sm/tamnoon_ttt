# Plan

Below is the plan for the app:

## Entry

When first entering the app, the user will need to type in a name and press a button to look for a game.
The button will be disabled if the name is empty / contains only spaces or similar.
There will be a text saying if another player is looking for a game right now.


## Queuing

When entering the queue, the user will see a text saying its waiting for another player.
When a player is found, it will start the game.

### What actually happens:

When entering the queue, the user will sub to the queue channel and activate a "handshake" method.
The handshake method will receive a "sender" argument, and if it is not provided or is equal to the self() pid it will ignore it. 
If not, it will publish a "start game" method in the queue channel with a "channel_name" value of the two PIDs concatenated.
It will also receive a "name" parameter and will assign it as the name of the other player.

The start game method will unsubscribe the client from the queue channel and subscribe it to the channel named as the "channel_name" argument.
It will also receive a "other name" argument, and if the sender is the other user it will assign it as the other player's name.
The start game method will also receive a sender argument, and if it is equal to the self() pid it will assign X to the player (and O otherwise). (The player's symbol will be stored in their state)
Finally, it will publish a "start turn" method in the match's channel with "player" = X.

## Gameplay

The start turn method receives a "player" argument, and if it is equal to the user's symbol, it will enable the buttons of the empty grid slots. If not, it will disable them.

The empty grid slots will publish a "handle move" method with their coordinates.
The handle move method receives coordinates (as "key") and:
1. checks for a win / draw - if game is over, publishes a "game over" method with the result.
2. if not, publishes a start turn method with the new current player.
3. updates the board.

The game over method will make disable the buttons of the whole board and update the page to display the result.

## Match end

When a match ends, a "play again" button will be displayed. On click, it will put the player in the start screen (with the name already filled).