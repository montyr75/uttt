import 'dart:html';
import 'dart:async';

List<TTTBoard> littleBoards;    // a list of all 9 small TTT boards
TTTBoard mainBoard;             // the large TTT board
String currentPlayer;           // "X" or "O"
List<int> currentMainSquares;   // small TTT board(s) for next move (0-8)
Map<DivElement, StreamSubscription> currentLittleSquares;

void main() {
  // TODO: If the HTML gets too ugly, consider building the board in code here.

  newGame();
}

void newGame() {
  littleBoards = new List<TTTBoard>.generate(9, (_) => new TTTBoard());
  mainBoard = new TTTBoard();
  currentPlayer = null;
  currentMainSquares = [];
  currentLittleSquares = {};

  calculateCurrentMainSquares();
  setUpNextMove();
}

void setUpNextMove() {
  // toggle current player
  currentPlayer = currentPlayer == "X" ? "O" : "X";

  // find, save, and highlight all legal moves (little squares)
  for (int mainSquare in currentMainSquares) {
    List<int> littleSquares = littleBoards[mainSquare].unoccupiedSquares;

    for (int littleSquare in littleSquares) {
      DivElement squareDiv = getLittleSquareDiv(mainSquare, littleSquare);
      currentLittleSquares[squareDiv] = squareDiv.onClick.listen((MouseEvent event) => move(mainSquare, littleSquare));
      squareDiv.classes.toggle("current-square");
    }
  }
}

void calculateCurrentMainSquares([int lastLittleSquare]) {
  currentMainSquares.clear();

  if (lastLittleSquare != null && mainBoard[lastLittleSquare] == null) {
    currentMainSquares.add(lastLittleSquare);
  }
  else {
    currentMainSquares = mainBoard.unoccupiedSquares;
  }
}

// called by mouse click
void move(int mainSquare, int littleSquare) {
  // remove click listeners from last turn
  currentLittleSquares.forEach((DivElement squareDiv, StreamSubscription listener) {
    squareDiv.classes.toggle("current-square");
    listener.cancel();
  });

  currentLittleSquares.clear();

  getLittleSquareDiv(mainSquare, littleSquare).text = currentPlayer;

  String littleBoardWinner = littleBoards[mainSquare].move(littleSquare, currentPlayer);

  if (littleBoardWinner != null) {
    String mainBoardWinner = mainBoard.move(mainSquare, littleBoardWinner);

    DivElement mainSquareDiv = getMainSquareDiv(mainSquare);
    mainSquareDiv.children.clear();
    mainSquareDiv.appendHtml('<span class="main-mark">$littleBoardWinner</span>');

    if (mainBoardWinner != null) {
      // TODO: PLAYER currentPlayer WINS!
      // TODO: return and end the game
    }
  }

  calculateCurrentMainSquares(littleSquare);
  setUpNextMove();
}

DivElement getMainSquareDiv(int mainSquare) {
  return querySelector('.main-square[data-square="$mainSquare"]');
}

DivElement getLittleSquareDiv(int mainSquare, int littleSquare) {
  return querySelector('.main-square[data-square="$mainSquare"] .little-square[data-square="$littleSquare"]');
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

  List<int> get unoccupiedSquares {
    List<int> squares = [];

    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == null) {
        squares.add(i);
      }
    }

    return squares;
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