import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_tiles/home_controller.dart';
import 'package:musical_tiles/local_storage.dart';
import 'package:musical_tiles/widgets/box.dart';

class TilesScreen extends StatefulWidget {
  final int horizontalDivision;
  final int verticalBoxCount;
  const TilesScreen(
      {super.key, this.horizontalDivision = 3, required this.verticalBoxCount});

  @override
  State<TilesScreen> createState() => _TilesScreenState();
}

class _TilesScreenState extends State<TilesScreen> {
  final HomeController _controller = Get.put(HomeController());
  int divider = 10;
  bool _isPlayed = false;

  @override
  void initState() {
    if (widget.horizontalDivision <= 5) {
      _controller.setHorizontalDivision = widget.horizontalDivision;
      _controller.setVerticalBoxCount = widget.verticalBoxCount;
    }
    // Future.delayed(Duration(seconds: 2), () {
    //   _mover();
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getScore() {
    return Get.find<LocalStorage>().getScore(widget.horizontalDivision) ?? 0;
  }

  final _simpleClickAudio = 'assets/simple_click.mp3';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            // alignment: Alignment.center,
            children: [
              Column(
                  children: List.generate(
                      _controller.totalYboxes,
                      (y) => Row(
                            children:
                                List.generate(_controller.totalXboxes, (x) {
                              return Obx(() {
                                final currentPosition = Position(x: x, y: y);
                                final isSelected = _controller.selectedBoxes
                                    .contains(currentPosition.toString());

                                return GestureDetector(
                                    onTapDown: (details) {
                                      AssetsAudioPlayer.playAndForget(
                                          Audio(_simpleClickAudio));
                                    },
                                    onTap: () {
                                      if (_controller.gameState.value !=
                                          GameState.stopped) {
                                        _controller
                                            .hidePosition(Position(x: x, y: y));
                                      }
                                    },
                                    child: BoxWidget(
                                        x: x,
                                        y: y,
                                        isHidden: _controller
                                            .isPositionHidden(currentPosition),
                                        isSelected: isSelected,
                                        width: _controller.baseWidthDimention,
                                        height:
                                            _controller.baseHeightDimention));
                              });
                            }),
                          ))),
              Obx(() => Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            "score : ${_controller.scoreCount}",
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Max : ${getScore()}",
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  )),
              Obx(() {
                final gameState = _controller.gameState.value;
                if (gameState == GameState.stopped) {
                  return Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: InkWell(
                                onTap: () {
                                  _controller.playNewGame();
                                  _isPlayed = true;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 48,
                                  ),
                                ),
                              )),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isPlayed)
                                  Column(
                                    children: [
                                      Text(
                                        "You scored : ${_controller.scoreCount}",
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                Text(
                                  "Max score is : ${getScore()}",
                                  style: TextStyle(
                                      fontSize: _isPlayed ? 18 : 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(top: 28.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.chevron_left),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(' Go back '),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              })
            ],
          ),
          // floatingActionButton: FloatingActionButton.small(
          //   onPressed: () {
          //     _controller.playNewGame();
          //   },
          //   child: Text('Stop'),
          // ),
        ),
      ),
    );
  }
}
