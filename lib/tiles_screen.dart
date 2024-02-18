import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:musical_tiles/home_controller.dart';
import 'package:musical_tiles/widgets/box.dart';

class TilesScreen extends StatefulWidget {
  final int horizontalDivision;
  const TilesScreen({super.key, this.horizontalDivision = 3});

  @override
  State<TilesScreen> createState() => _TilesScreenState();
}

class _TilesScreenState extends State<TilesScreen> {
  final HomeController _controller = Get.put(HomeController());
  int divider = 10;

  @override
  void initState() {
    if (widget.horizontalDivision <= 5) {
      _controller.setHorizontalDivision = widget.horizontalDivision;
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
                                        height: _controller.baseHeightDimention));
                              });
                            }),
                          ))),
              Obx(() => Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "score : ${_controller.scoreCount}",
                      style: const TextStyle(fontSize: 28),
                    ),
                  ))),
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
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              _controller.playNewGame();
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
                          ),
                        )),
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
