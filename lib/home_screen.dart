import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_tiles/local_storage.dart';
import 'package:musical_tiles/tiles_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final verticalCountMap = {2: 12, 3: 10, 4: 12, 5: 12};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "Tile run pro max +",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: verticalCountMap.keys.toList().map((key) {
                    var previousCount =
                        Get.find<LocalStorage>().getScore(key) ?? 0;
                    return InkWell(
                      splashColor: Colors.purpleAccent,
                      focusColor: Colors.purpleAccent,
                      onTap: () async {
                        await Get.to(() => TilesScreen(
                              horizontalDivision: key,
                              verticalBoxCount: verticalCountMap[key] ?? 8,
                            ));
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1, color: Colors.purple.shade100),
                            borderRadius: BorderRadius.circular(8)),
                        margin: const EdgeInsets.all(12),
                        child: Column(children: [
                          Expanded(
                            child: Center(
                                child: Text(
                              "$key Tiles",
                              style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          if (previousCount > 0)
                            Container(
                              padding: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              color: Colors.green.shade100,
                              child: FittedBox(
                                child: Text(
                                  "Max : $previousCount tiles",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green.shade900),
                                ),
                              ),
                            )
                        ]),
                      ),
                    );
                  }).toList()),
              Spacer(),
              Container(
                height: 150,
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
                child: Image.asset('assets/dancing_gif.gif'),
              ),
              Container(
                padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
                child: const Text(
                  'An idea of Ankit Maurya ⚔️',
                  style: TextStyle(color: Colors.purple),
                ),
              )
            ],
          ),
        ));
  }
}
