import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:musical_tiles/tiles_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Musical Tiles Pro"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 150),
                Column(
                    children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.purple,
                            onTap: () {
                              Get.to(()=>TilesScreen(
                                horizontalDivision: index + 2,
                              ));
                            },
                            child: Container(
                              color:
                                  Colors.purpleAccent.shade100.withOpacity(0.5),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'Go to Musical tiles  ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.purple),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color:
                                  Colors.purpleAccent.shade100.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            '${index + 2} Tiles',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()),
                Spacer(),
                //todox
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Image.asset('assets/dancing_gif.gif'),
                // )
              ]),
        ));
  }
}
