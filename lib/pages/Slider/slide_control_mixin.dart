// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_puzzle/Models/custom_image.dart';
import 'package:slide_puzzle/Models/model.dart';
import 'package:slide_puzzle/pages/Slider/bottom_bar.dart';
import 'package:slide_puzzle/pages/Slider/slider.dart';

mixin SlideControlMixin on State<SliderPuzzle> {
  AnimationController get animController;

  RxList<Model> list = <Model>[].obs;

  RxInt count = 0.obs;
  RxInt steps = 0.obs;
  RxBool isLoaded = false.obs;
  RxBool isSolved = true.obs;

  initialize() async {
    CustomImage image = CustomImage(
        imagePath: 'img/pic.png', size: widget.size, cut: widget.cut);
    list.value = await image.splitImage();
    count(list.value.length);
    steps(0);
    isLoaded(true);
  }

  shuffle() {
    list.value.shuffle();
    isSolved.value = checkSolve();
  }

  checkSolve() {
    count.value = 0;
    for (int i = 0; i < list.value.length; i++) {
      count.value += list.value[i].index == i ? 1 : 0;
    }
    return count.value == list.value.length;
  }

  solve() {
    list.value.sort((a, b) => a.index.compareTo(b.index));

    isSolved.value = checkSolve();
  }

  buildBody() {
    const margin = 4;
    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(.2),
                width: widget.size + (widget.cut + 1) * margin,
                height: widget.size + (widget.cut + 1) * margin,
              ),
              ...List.generate(
                list.length,
                (i) => positionedTile(i, list.value[i], margin),
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
      ),
    );
  }

  positionedTile(i, e, margin) {
    var top =
        (e.index / widget.cut).floor() * (widget.size / widget.cut + margin) +
            margin;
    var left =
        (e.index % widget.cut) * (widget.size / widget.cut + margin) + margin;
    return AnimatedPositioned(
      top: top,
      left: left,
      duration: const Duration(seconds: 1),
      child: itemCard(i, e),
    );
  }

  itemCard(index, e) {
    var lastIndex = list.value.length - 1;
    return GestureDetector(
      onTap: () {
        steps.value++;
        var dif = (lastIndex - index).abs();
        if (dif == 1 || dif == widget.cut) {
          list.value[index] = list.value[lastIndex];
          list.value[lastIndex] = e;
        }
        isSolved.value = checkSolve();
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
              index.toString() + e.index.toString(),
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
