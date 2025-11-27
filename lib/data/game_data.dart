import 'package:flutter/material.dart';

enum Player {
  x,
  o;

  @override
  String toString() => name.toUpperCase();

  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return this == Player.x ? colorScheme.secondary : colorScheme.tertiary;
  }
}

const winPatterns = [
  // Rows
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  // Columns
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  // Diagonals
  [0, 4, 8],
  [2, 4, 6],
];
