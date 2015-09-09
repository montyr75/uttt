import 'dart:html';
import 'dart:async';

TTTBoard mainBoard;               // the large TTT board
List<TTTBoard> littleBoards;      // a list of all 9 small TTT boards
String currentPlayer;             // "X" or "O"
List<int> availableMainSquares;   // main squares available for next move
Map<DivElement, StreamSubscription> availableLittleSquares;

DivElement messageDiv = querySelector("#message");

void main() {
  querySelector("#new-game-btn").onClick.listen(newGame);
  newGame();
}

void newGame([MouseEvent event]) {
  mainBoard = new TTTBoard();
  littleBoards = new List<TTTBoard>.generate(9, (_) => new TTTBoard());
  currentPlayer = null;
  availableMainSquares = [];
  availableLittleSquares = {};

  createBoard();
  nextTurn();
}

void createBoard() {
  DivElement mainBoardDiv = querySelector("#main-board")..children.clear();
  for (int mainSquare = 0; mainSquare < 9; mainSquare++) {
    DivElement mainSquareDiv = new DivElement()
      ..classes.addAll(["main-square", "layout", "horizontal", "center", "center-justified", "wrap"])
      ..attributes['data-square'] = mainSquare.toString();

    mainBoardDiv.append(mainSquareDiv);

    for (int littleSquare = 0; littleSquare < 9; littleSquare++) {
      mainSquareDiv.append(new DivElement()
        ..classes.addAll(["little-square", "layout", "horizontal", "center", "center-justified"])
        ..attributes['data-square'] = littleSquare.toString());
    }
  }
}

void nextTurn([int lastLittleSquare]) {
  // toggle current player
  currentPlayer = currentPlayer == "X" ? "O" : "X";
  messageDiv.text = "Player: $currentPlayer";

  findAvailableSquares(lastLittleSquare);
}

void findAvailableSquares([int lastLittleSquare]) {
  // figure out which main squares are available
  availableMainSquares.clear();

  if (lastLittleSquare != null && mainBoard[lastLittleSquare] == null) {
    availableMainSquares.add(lastLittleSquare);
  }
  else {
    availableMainSquares = mainBoard.unoccupiedSquares;
  }

  // find, save, and highlight all legal moves (little squares)
  for (int mainSquare in availableMainSquares) {
    List<int> littleSquares = littleBoards[mainSquare].unoccupiedSquares;

    for (int littleSquare in littleSquares) {
      DivElement squareDiv = getLittleSquareDiv(mainSquare, littleSquare);
      squareDiv.classes.toggle("current-square");
      availableLittleSquares[squareDiv] = squareDiv.onClick.listen(
        (MouseEvent event) => move(mainSquare, littleSquare)
      );
    }
  }

  // if the player has nowhere to move, he/she can move anywhere
  if (availableLittleSquares.isEmpty) {
    findAvailableSquares();
  }
}

void clearAvailableLittleSquares() {
  // remove click listeners from last turn
  availableLittleSquares.forEach((DivElement squareDiv, StreamSubscription listener) {
    squareDiv.classes.toggle("current-square");
    listener.cancel();
  });

  availableLittleSquares.clear();
}

void move(int mainSquare, int littleSquare) {
  clearAvailableLittleSquares();

  getLittleSquareDiv(mainSquare, littleSquare).text = currentPlayer;

  String littleBoardWinner = littleBoards[mainSquare].move(littleSquare, currentPlayer);

  if (littleBoardWinner != null) {
    String mainBoardWinner = mainBoard.move(mainSquare, littleBoardWinner);

    DivElement mainSquareDiv = getMainSquareDiv(mainSquare);
    mainSquareDiv.children.clear();
    mainSquareDiv.appendHtml('<span class="main-mark">$littleBoardWinner</span>');

    if (mainBoardWinner != null) {
      clearAvailableLittleSquares();
      messageDiv.text = "Player $mainBoardWinner wins!";
      return;
    }
  }

  nextTurn(littleSquare);
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