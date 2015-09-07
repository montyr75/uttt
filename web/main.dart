import 'dart:html';

List<TTTBoard> littleBoards;    // a list of all 9 small TTT boards
TTTBoard mainBoard;             // the large TTT board
String currentPlayer;           // "X" or "O"
int currentBoard;               // small TTT board for next move (0-8)

void main() {
  newGame();
}

void newGame() {
  // TODO: If the HTML gets too ugly, consider building the board in code here.

  littleBoards = new List<TTTBoard>.generate(9, (_) => new TTTBoard());
  mainBoard = new TTTBoard();
  currentPlayer = null;
  currentBoard = null;

  setUpNextMove();
}

void setUpNextMove() {
  currentPlayer = currentPlayer == "X" ? "O" : "X";

  // TODO: Listen for clicks only on unoccupied squares in currentBoard (they call move())
  // TODO: If currentBoard is null, listen on ALL unoccupied squares in unoccupied mainBoard squares
  // TODO: Mark all valid squares with CSS
}

// called by mouse click
// 'square' is the little square clicked (0-8)
void move(int square) {
  // TODO: Put currentPlayer into little board DOM

  String littleBoardWinner = littleBoards[currentBoard].move(square, currentPlayer);

  if (littleBoardWinner != null) {
    String mainBoardWinner = mainBoard.move(currentBoard, littleBoardWinner);

    // TODO: Put littleBoardWinner into main board DOM

    if (mainBoardWinner != null) {
      // TODO: PLAYER currentPlayer WINS!
      // TODO: return and end the game
    }
  }

  // if mainBoard[square] is unoccupied, set it as currentBoard
  currentBoard = mainBoard[square] == null ? square : null;

  setUpNextMove();
}

class TTTBoard {
  // win patterns
  static const List<List<int>> WIN_PATTERNS = const [
    const [0, 1, 2],  // row 1
    const [3, 4, 5],  // row 2
    const [6, 7, 8],  // row 3
    const [0, 3, 6],  // col 1
    const [1, 4, 7],  // col 2
    const [2, 5, 8],  // col 3
    const [0, 4, 8],  // diag 1
    const [2, 4, 6]   // diag 2
  ];

  List<String> _board;

  TTTBoard() {
    _board = new List<String>.filled(9, null);
  }

  String move(int square, String player) {
    _board[square] = player;
    return checkWin();
  }

  String checkWin() {
    for (List<int> winPattern in WIN_PATTERNS) {
      String square1 = _board[winPattern[0]];
      String square2 = _board[winPattern[1]];
      String square3 = _board[winPattern[2]];

      // if all three squares match and aren't empty, there's a win
      if (square1 != null && square1 == square2 && square2 == square3) {
        return square1;
      }
    }

    // if we get here, there is no win
    return null;
  }

  String operator [](int square) => _board[square];

  @override String toString() {
    String mark(int square) {
      return _board[square] ?? " ";
    }

    return """
${mark(0)} | ${mark(1)} | ${mark(2)}
${mark(3)} | ${mark(4)} | ${mark(5)}
${mark(6)} | ${mark(7)} | ${mark(8)}
    """;
  }
}