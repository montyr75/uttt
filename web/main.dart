import 'dart:html';
import 'dart:async' show StreamSubscription;

TTTBoard mainBoard; // the large TTT board
List<TTTBoard> littleBoards; // a list of all 9 small TTT boards
String currentPlayer; // "X" or "O"
List<int> availableMainSquares; // main squares available for next move
Map<DivElement, StreamSubscription> availableLittleSquares;

DivElement mainBoardDiv = querySelector("#main-board");
DivElement messageDiv = querySelector("#message");

void main() {
  querySelector("#new-game-btn").onClick.listen(newGame);
  newGame();
}

DivElement getMainSquareDiv(int mainSquare) =>
    querySelector('.main-square[data-square="$mainSquare"]');

DivElement getLittleSquareDiv(int mainSquare, int littleSquare) => querySelector(
    '.main-square[data-square="$mainSquare"] > [data-square="$littleSquare"]');

bool toggleHighlight(DivElement squareDiv) =>
    squareDiv.classes.toggle("available-square");

String markSquare(DivElement squareDiv, String player) =>
    squareDiv.text = player;

String showMessage(String msg) => messageDiv.text = msg;

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
  mainBoardDiv.children.clear();

  List<String> layoutClasses = [
    "layout",
    "horizontal",
    "center",
    "center-justified"
  ];

  for (int mainSquare = 0; mainSquare < 9; mainSquare++) {
    DivElement mainSquareDiv = new DivElement()
      ..classes.addAll(["main-square", "wrap"]..addAll(layoutClasses))
      ..attributes['data-square'] = mainSquare.toString();

    mainBoardDiv.append(mainSquareDiv);

    for (int littleSquare = 0; littleSquare < 9; littleSquare++) {
      mainSquareDiv.append(new DivElement()
        ..classes.addAll(["little-square"]..addAll(layoutClasses))
        ..attributes['data-square'] = littleSquare.toString());
    }
  }
}

void nextTurn([int lastLittleSquare]) {
  // toggle current player
  currentPlayer = currentPlayer == "X" ? "O" : "X";
  showMessage("Player: $currentPlayer");

  // figure out which main squares are available
  if (lastLittleSquare != null &&
      mainBoard[lastLittleSquare] == null &&
      littleBoards[lastLittleSquare].isNotFull) {
    availableMainSquares = [lastLittleSquare];
  }
  else {
    availableMainSquares = mainBoard.emptySquares;
  }

  // find, save, and highlight all available little squares
  for (int mainSquare in availableMainSquares) {
    for (int littleSquare in littleBoards[mainSquare].emptySquares) {
      DivElement squareDiv = getLittleSquareDiv(mainSquare, littleSquare);
      toggleHighlight(squareDiv);
      availableLittleSquares[squareDiv] = squareDiv.onClick
          .listen((MouseEvent event) => move(mainSquare, littleSquare));
    }
  }
}

void move(int mainSquare, int littleSquare) {
  // remove click listeners from last turn
  availableLittleSquares
    ..forEach((DivElement squareDiv, StreamSubscription listener) {
      toggleHighlight(squareDiv);
      listener.cancel();
    })
    ..clear();

  // make the move
  String littleBoardWinner =
      littleBoards[mainSquare].move(littleSquare, currentPlayer);
  markSquare(getLittleSquareDiv(mainSquare, littleSquare), currentPlayer);

  // if there is a win on a little board, make a move on the main board
  if (littleBoardWinner != null) {
    String mainBoardWinner = mainBoard.move(mainSquare, littleBoardWinner);
    markSquare(
        getMainSquareDiv(mainSquare)..children.clear(), littleBoardWinner);

    // check for win or tie on main board
    if (mainBoardWinner != null) {
      showMessage("Player $mainBoardWinner wins!");
      return;
    }
    else if (mainBoard.isFull) {
      showMessage("It's a tie!");
      return;
    }
  }

  nextTurn(littleSquare);
}

class TTTBoard {
  static const List<List<int>> WIN_PATTERNS = const [
    const [0, 1, 2], // row 1
    const [3, 4, 5], // row 2
    const [6, 7, 8], // row 3
    const [0, 3, 6], // col 1
    const [1, 4, 7], // col 2
    const [2, 5, 8], // col 3
    const [0, 4, 8], // diag 1
    const [2, 4, 6]  // diag 2
  ];

  List<String> _board;
  int _moveCount = 0;

  TTTBoard() {
    _board = new List<String>.filled(9, null);
  }

  String getWinner() {
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

  String move(int square, String player) {
    _board[square] = player;
    _moveCount++;
    return getWinner();
  }

  bool get isFull => _moveCount >= 9;
  bool get isNotFull => !isFull;

  List<int> get emptySquares {
    List<int> empties = [];

    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == null) {
        empties.add(i);
      }
    }

    return empties;
  }

  String operator [](int square) => _board[square];

  @override String toString() {
    String prettify(int square) => _board[square] ?? " ";

    return """
${prettify(0)} | ${prettify(1)} | ${prettify(2)}
${prettify(3)} | ${prettify(4)} | ${prettify(5)}
${prettify(6)} | ${prettify(7)} | ${prettify(8)}
    """;
  }
}
