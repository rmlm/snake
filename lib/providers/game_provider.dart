import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../enums/direction.dart';
import '../enums/game_state.dart';

class GameProvider extends ChangeNotifier {
  final int _numberOfRows = 40;
  final int _numberOfColumns = 20;
  final int _numberOfApples = 100;
  final int _snakeInitialSize = 7;

  int _score = 0;

  final List<int> _snakePositions = [];
  final List<int> _applesPositions = [];

  Direction _currentSnakeDirection = Direction.right;
  GameState _currentGameState = GameState.toStart;

  StreamSubscription? _timer;

  int get numberOfRows => _numberOfRows;
  int get numberOfColumns => _numberOfColumns;
  int get score => _score;

  List<int> get snake => _snakePositions;
  List<int> get apples => _applesPositions;

  GameState get gameState => _currentGameState;

  int get _snakeHead => _snakePositions.last;

  void startGame() {
    _initializeSnake();
    _generateApples(
      number: _numberOfApples,
      firstTime: true,
    );

    _currentGameState = GameState.started;
    _currentSnakeDirection = Direction.right;
    _timer = Stream.periodic(const Duration(milliseconds: 300)).listen((event) {
      _moveSnake();
    });
  }

  void pauseGame() {}

  void _gameOver() async {
    _currentGameState = GameState.gameover;
    await _timer!.cancel();

    notifyListeners();
  }

  void changeDirection(int position) {
    final newDirection = _getNewDirection(position);

    if (newDirection != null && _canChangeDirection(newDirection)) {
      _currentSnakeDirection = newDirection;
      notifyListeners();
    }
  }

  Direction? _getNewDirection(int position) {
    final rowClicked = _getRowOfPosition(position);
    final columnClicked = _getColumnOfPosition(rowClicked, position);
    final rowOfSnake = _getRowOfPosition(_snakeHead);
    final columnOfSnake = _getColumnOfPosition(rowOfSnake, _snakeHead);

    if (_currentSnakeDirection == Direction.left ||
        _currentSnakeDirection == Direction.right) {
      if (rowClicked < rowOfSnake) return Direction.top;
      if (rowClicked > rowOfSnake) return Direction.bottom;
    } else {
      if (columnClicked < columnOfSnake) return Direction.left;
      if (columnClicked > columnOfSnake) return Direction.right;
    }

    return null;
  }

  int _getRowOfPosition(int position) {
    return (position / _numberOfColumns).floor();
  }

  int _getColumnOfPosition(int row, int position) {
    return position - (row * _numberOfColumns);
  }

  bool _canChangeDirection(Direction newDirection) {
    if (_currentSnakeDirection == newDirection) return false;

    switch (newDirection) {
      case Direction.left:
        return _currentSnakeDirection != Direction.right;
      case Direction.top:
        return _currentSnakeDirection != Direction.bottom;
      case Direction.right:
        return _currentSnakeDirection != Direction.left;
      case Direction.bottom:
        return _currentSnakeDirection != Direction.top;
    }
  }

  bool _handleSnakeWallsColision() {
    final rowOfSnake = _getRowOfPosition(_snakeHead);
    final columnOfSnake = _getColumnOfPosition(rowOfSnake, _snakeHead);

    final firstRow = rowOfSnake == 0;
    final lastRow = rowOfSnake == (_numberOfRows - 1);

    final firstColumn = columnOfSnake == 0;
    final lastColumn = columnOfSnake == (_numberOfColumns - 1);

    switch (_currentSnakeDirection) {
      case Direction.right:
        if (lastColumn) _gameOver();
        break;
      case Direction.left:
        if (firstColumn) _gameOver();
        break;
      case Direction.top:
        if (firstRow) _gameOver();
        break;
      case Direction.bottom:
        if (lastRow) _gameOver();
        break;
    }

    return _currentGameState == GameState.gameover;
  }

  void _handleSnakeBodyColision() {
    final nextBlock = _getNextPositionOfSnake();

    if (nextBlock == null || _snakePositions.contains(nextBlock)) {
      _gameOver();
    }
  }

  bool _handleAppleColision() {
    bool eated = false;

    if (_applesPositions.contains(_snakeHead)) {
      final nextPosition = _getNextPositionOfSnake();

      if (nextPosition != null) {
        _applesPositions.remove(_snakeHead);
        _snakePositions.add(nextPosition);

        _generateApples(number: 1);
        _score += 1;

        eated = true;
      }
    }

    return eated;
  }

  void _moveSnake() {
    int? positionToAdd = _getNextPositionOfSnake();

    if (_handleSnakeWallsColision()) return;
    if (_handleAppleColision()) {
      notifyListeners();
      return;
    }

    if (positionToAdd != null) {
      _snakePositions.removeAt(0);
      _snakePositions.add(positionToAdd);

      _handleSnakeBodyColision();

      notifyListeners();
    }
  }

  int? _getNextPositionOfSnake() {
    int? positionToAdd;

    switch (_currentSnakeDirection) {
      case Direction.right:
        positionToAdd = _snakePositions.last + 1;
        break;
      case Direction.bottom:
        positionToAdd = _snakePositions.last + _numberOfColumns;
        break;
      case Direction.left:
        positionToAdd = _snakePositions.last - 1;
        break;
      case Direction.top:
        positionToAdd = _snakePositions.last - _numberOfColumns;
    }

    return positionToAdd;
  }

  void _initializeSnake() {
    _snakePositions.clear();
    for (var i = 0; i < _snakeInitialSize; i++) {
      _snakePositions.add(i);
    }
  }

  void _generateApples({
    required int number,
    bool firstTime = false,
  }) {
    var random = Random();

    if (firstTime) _applesPositions.clear();

    for (var i = 0; i < number; i++) {
      var position = random.nextInt(_numberOfRows * _numberOfColumns);

      if (firstTime && position <= _numberOfColumns) {
        position += _numberOfColumns;
      }
      if (!_applesPositions.contains(position)) _applesPositions.add(position);
    }
  }
}
