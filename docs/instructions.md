# Ultimate Tic-Tac-Toe

Ultimate Tic-Tac-Toe is a variant of Tic-Tac-Toe where players take turns marking spaces in a 3x3 grid of smaller 3x3 Tic-Tac-Toe boards. The game is played on a large Tic-Tac-Toe board, with each square containing a smaller Tic-Tac-Toe board. The objective of the game is to win three of your symbols in a row on the large board. The game is for two players, X and O, who take turns marking spaces in the small boards.

## How to Play
*   **First move**: The first player can choose any small square on any of the nine small Tic-Tac-Toe boards.
*   **Subsequent moves**: Your opponent must play in the small board that corresponds to the position of your last move. For example, if you play in the top-left square of any board, your opponent must play in the top-left board.
*   **Winning a small board**: When you get three of your symbols in a row on a small board, you win that board. That entire square is marked with your symbol, and the small board is removed from the game.
*   **Winning the game**: The first player to get three of their symbols in a row on the large Tic-Tac-Toe board wins the game.

## Special Cases
*   **Sent to a won board**: If you are directed to a board that has already been won, you are allowed to play in any available square on any board.
*   **Sent to a full board**: If a small board is full (a tie), the player who is sent to that board can play in any open square.