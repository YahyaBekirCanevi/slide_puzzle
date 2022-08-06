// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_puzzle/pages/game/bottom_bar/bottom_bar.dart';
import 'package:slide_puzzle/pages/game/model.dart';
import 'package:slide_puzzle/pages/game/slide/slider.dart';
import 'package:slide_puzzle/utils/custom_image.dart';

mixin SlideControlMixin on State<SliderPuzzle> {
  AnimationController get animController;

  RxList<Model> list = <Model>[].obs;

  RxInt count = 0.obs;
  RxInt steps = 0.obs;
  RxBool isLoaded = false.obs;
  RxBool isSolved = true.obs;

  initialize() async {
    print("initialize");
    CustomImage image = CustomImage(
        imagePath: 'img/pic.png', size: widget.size, cut: widget.cut);
    list.value = await image.splitImage();
    count(list.value.length);
    steps(0);
    isLoaded(true);
  }

  shuffle() {
    print("shuffle");
    list.value.shuffle();
    isSolved.value = checkSolve();
  }

  checkSolve() {
    print("checkSolve");
    count.value = 0;
    for (int i = 0; i < list.value.length; i++) {
      count.value += list.value[i].index == i ? 1 : 0;
    }
    return count.value == list.value.length;
  }

  solve() {
    print("solve");
    list.value.sort((a, b) => a.index.compareTo(b.index));

    isSolved.value = checkSolve();
  }

  buildBody() {
    print("buildBody");
    const margin = 4;
    var size = widget.size + (widget.cut + 1) * margin;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black.withOpacity(.2),
              width: size,
              height: size,
            ),
            ...List.generate(
              list.length,
              (i) => positionedTile(i, margin),
            ),
          ],
        ),
        BottomBar(
          steps: steps.value.toDouble(),
          count: count.value.toDouble(),
          shuffle: () => shuffle(),
          solve: () => solve(),
        ),
      ],
    );
  }

  positionedTile(i, margin) {
    print("positionedTile $i");
    var size = widget.size / widget.cut + margin;
    var top = (list.value[i].index / widget.cut).floor() * size + margin;
    var left = (list.value[i].index % widget.cut) * size + margin;
    return /* Animated */ Positioned(
      top: top,
      left: left,
      //duration: const Duration(seconds: 1),
      child: tile(i),
    );
  }

  tile(i) {
    var index = list.value[i].index;
    var lastIndex = list.value.length - 1;
    print("tile $i $index");
    return GestureDetector(
      onTap: () {
        steps.value++;
        var dif = (lastIndex - index).abs();
        if (dif == 1 || dif == widget.cut) {
          var e = list.value[index];
          list.value[index] = list.value[lastIndex];
          list.value[lastIndex] = e;
          print("switch $index $lastIndex");
          isSolved.value = checkSolve();
        }
      },
      child: Stack(
        children: [
          Obx(
            () => !isSolved.value && list.value[index].index == lastIndex
                ? Container(
                    color: Colors.transparent,
                    width: widget.size / widget.cut,
                    height: widget.size / widget.cut,
                  )
                : list.value[index].widget,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              index.toString() + list.value[index].index.toString(),
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
