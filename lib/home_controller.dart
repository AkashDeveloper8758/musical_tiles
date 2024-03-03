// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import 'package:musical_tiles/local_storage.dart';

enum GameState { playing, stopped }

int _initialMovingDuration = 40;

// time increment gap ( in seconds )
const int _incrementTimeGap = 20;

class HomeController extends GetxController {
  // RxSet<Tuple> selectedSet = RxSet();
  RxInt scoreCount = 0.obs;
  Rx<GameState> gameState = Rx(GameState.stopped);
  RxInt timeCountValue = 0.obs;

  RxSet<String> selectedBoxes = RxSet();
  // minimum moving duration ( in milliseconds )
  Duration _movingDuration = Duration(milliseconds: _initialMovingDuration);

  // minimum duration in milliseconds
  final int _minimumDurationAllwoed = 5;

  final List<Block> _masterPointsList = [];
  final Map<String, int> _blockIdByPositionMap = {};
  RxSet<int> selectedIds = RxSet();

  //* ------ dimentions and helpers getters

  int _horizontalDivision = 4;
  // set vertical division
  final int _verticalDivision = 30;

  set setHorizontalDivision(int value) => _horizontalDivision = value;

  final _random = Random();
  int get horizontalCount => _horizontalDivision;

  int _verticalC = 15;
  set setVerticalBoxCount(int count) => _verticalC = count;
  int get _verticalBoxHeightCount => _verticalC;

// -------------------- DIMENSIONS & COUNT --------------------------------
  double get baseWidthDimention => Get.width / horizontalCount;
  double get baseHeightDimention =>
      (Get.height -
          Get.mediaQuery.padding.bottom -
          Get.mediaQuery.padding.top) /
      _verticalDivision;

  int get totalXboxes => horizontalCount;
  int get totalYboxes => _verticalDivision;
// ------------------------------------------------------------------------

  final _gameOverAudio = 'assets/paper_sound_2.mp3';
  final _piano = 'assets/paper_sound.mp3';

  int getRandomNumber(int min, int max) => min + _random.nextInt(max - min);
  int get getRandomXposition => getRandomNumber(0, _horizontalDivision);

  _stopGame() {
    gameState.value = GameState.stopped;
    _stopTimers();
  }

  playNewGame() {
    _stopTimers();
    _resetGame();
    _startGame();
  }

  _resetGame() {
    scoreCount.value = 0;
    selectedBoxes.clear();
    _movingDuration = Duration(milliseconds: _initialMovingDuration);
    _blockIdByPositionMap.clear();
    _masterPointsList.clear();
    selectedIds.clear();
  }

  //---------- timers ----
  Timer? _durationTimer;
  Timer? _innerLoopTimer;

  _stopTimers() {
    _innerLoopTimer?.cancel();
    _durationTimer?.cancel();
  }

  @override
  void onClose() {
    _stopTimers();
  }

  bool isPositionHidden(Position position) {
    var blockId = _blockIdByPositionMap[position.toString()];

    if (blockId != null) {
      return selectedIds.contains(blockId);
    }
    return false;
  }

  hidePosition(Position position) async {
    var blockId = _blockIdByPositionMap[position.toString()];
    if (blockId != null) {
      selectedIds.add(blockId);
      scoreCount.value += 1;
    
    } else {
      _callGameOver();
    }
  }

  _generateBlock(Block mp) {
    // selectedSet.clear();

    Set<String> tempBlockSet = selectedBoxes.toSet();
    for (var i = 0; i < _verticalBoxHeightCount; i++) {
      final position = Position(x: mp.position.x, y: mp.position.y - i - 1);

      _blockIdByPositionMap[position.toString()] = mp.id;
      tempBlockSet.add(position.toString());
    }

    // var now = DateTime.now();
    selectedBoxes = RxSet(tempBlockSet);
    // dev.log(
    //     '--- > time taken : ${DateTime.now().difference(now).inMilliseconds} ');
  }

  _startGame() {
    AssetsAudioPlayer.playAndForget(Audio(_piano));

    gameState.value = GameState.playing;
    _startTiles();
    _durationTimer?.cancel();
    _durationTimer =
        Timer.periodic(const Duration(seconds: _incrementTimeGap), (timer) {
      var newMilliseconds = _movingDuration.inMilliseconds - 5;
      if (newMilliseconds >= _minimumDurationAllwoed) {
        _movingDuration = Duration(milliseconds: newMilliseconds);
        _startTiles();
      }
    });
  }

  _callGameOver() {
    AssetsAudioPlayer.playAndForget(Audio(_gameOverAudio));

    _stopGame();
    final lc = Get.find<LocalStorage>();
    // update score if new score is greater then previous
    int previousScore = lc.getScore(_horizontalDivision) ?? 0;
    lc.setScore(
        tileCount: _horizontalDivision,
        score: max(previousScore, scoreCount.value));
  }

  _startTiles() {
    _innerLoopTimer?.cancel();
    _innerLoopTimer = Timer.periodic(_movingDuration, (timer) async {
      var now = DateTime.now();
      _blockIdByPositionMap.clear();
      selectedBoxes.clear();
      // dev.log(
      //     '--- > time taken x : ${DateTime.now().difference(now).inMilliseconds} ');
      if (_masterPointsList.isEmpty) {
        _masterPointsList
            .add(Block(position: Position(x: getRandomXposition, y: 0), id: 0));
      }

      for (var i = 0; i < _masterPointsList.length; i++) {
        final currPoint = _masterPointsList[i];
        _masterPointsList[i] = Block(
            position:
                Position(x: currPoint.position.x, y: currPoint.position.y + 1),
            id: currPoint.id);

        _generateBlock(currPoint);
      }
      if (_masterPointsList.last.position.y > _verticalBoxHeightCount) {
        //* --- add block

        _masterPointsList.add(Block(
            position: Position(x: getRandomXposition, y: 0),
            id: _masterPointsList.last.id + 1));
      }
      if (_masterPointsList[0].position.y >
          _verticalBoxHeightCount + totalYboxes) {
        //* --- Remove block
        if (!selectedIds.contains(_masterPointsList.first.id)) {
          _callGameOver();
        }
        _masterPointsList.removeAt(0);
      }
      dev.log(
          '--- > time taken : ${DateTime.now().difference(now).inMilliseconds} ');
    });
  }
}

class Block {
  final Position position;
  final int id;
  final bool isHidden;

  Block({required this.position, required this.id, this.isHidden = false});

  @override
  bool operator ==(covariant Block other) {
    if (identical(this, other)) return true;

    return other.position == position &&
        other.id == id &&
        other.isHidden == isHidden;
  }

  @override
  int get hashCode => 1;
}

class Position {
  final int x;
  final int y;

  Position({required this.x, required this.y});

  @override
  bool operator ==(covariant Position other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => 0;

  @override
  String toString() => '$x#$y';
}
