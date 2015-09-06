import 'dart:html';

void main() {
  TTTBoard board = new TTTBoard();

  print('Winner: ${board.move(4, "X") ?? "none"}');
  print('Winner: ${board.move(0, "X") ?? "none"}');
  print('Winner: ${board.move(8, "X") ?? "none"}');

  print(board);
}

class TTTBoard {
  // win patterns
  final List<List<int>> _winPatterns = const [
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
    for (List<int> winPattern in _winPatterns) {
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