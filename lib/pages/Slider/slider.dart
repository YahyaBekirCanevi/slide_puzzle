// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_puzzle/pages/Slider/slide_control_mixin.dart';

class SliderPuzzle extends StatefulWidget {
  const SliderPuzzle({Key? key, required this.size, required this.cut})
      : super(key: key);
  final double size;
  final int cut;

  @override
  State<SliderPuzzle> createState() => _SliderPuzzleState();
}

class _SliderPuzzleState extends State<SliderPuzzle>
    with SlideControlMixin, SingleTickerProviderStateMixin {
  //Widget fullImage = const SizedBox();
  @override
  late AnimationController animController;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
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
