import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_puzzle/Models/custom_image.dart';
import 'package:slide_puzzle/Models/model.dart';

class SliderPuzzle extends StatefulWidget {
  const SliderPuzzle({Key? key, required this.size, required this.cut})
      : super(key: key);
  final double size;
  final int cut;

  @override
  State<SliderPuzzle> createState() => _SliderPuzzleState();
}

class _SliderPuzzleState extends State<SliderPuzzle> {
  var list = <Model>[];

  Widget fullImage = const SizedBox();

  var isLoaded = false.obs;

  initialize() async {
    CustomImage image = CustomImage(
        imagePath: 'img/pic.png', size: widget.size, cut: widget.cut);
    fullImage = image.fullImage();
    list = await image.splitImage();
    isLoaded(true);
  }

  shuffle() {
    List<Model> temp = list;
    temp.shuffle();
    list = temp;
    list.map((e) => print(e.index));
    setState(() {});
  }

  buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black.withOpacity(.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                widget.cut,
                (i) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      widget.cut,
                      (j) => Container(
                        margin: const EdgeInsets.all(2),
                        child: Stack(
                          children: [
                            list[i * widget.cut + j].widget,
                            Positioned(
                              top: 2,
                              left: 2,
                              child: Container(
                                color: Colors.lightGreen,
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  list[i * widget.cut + j].index.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: InkWell(
            onTap: () => shuffle(),
            child: const Icon(
              Icons.shuffle,
              size: 30,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return isLoaded.value
          ? buildBody()
          : FutureBuilder(
              future: initialize(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return buildBody();
              },
            );
    });
  }
}
