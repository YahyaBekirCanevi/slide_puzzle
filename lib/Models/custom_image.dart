// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:slide_puzzle/Models/model.dart';

class CustomImage {
  CustomImage({
    required this.cut,
    required this.size,
    required this.imagePath,
  }) {
    //image = imglib.Image.asset(imageFile).obs;
  }
  final String imagePath;
  final double size;
  final int cut;
  //late Rx<Image> image;

  fullImage() => _getCanvas(AssetImage(imagePath), size);

  _getCanvas(image, size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: image,
        fit: BoxFit.scaleDown,
      )),
    );
  }

  Future<List<Model>> splitImage() async {
    try {
      ByteData imageByteData = await rootBundle.load(imagePath);
      List<int> values = imageByteData.buffer.asUint8List();
      imglib.Image? photo = imglib.decodeImage(values);

      if (photo == null) return [];
      imglib.Image image = imglib.copyResize(photo, width: size.floor());

      int x = 0, y = 0;
      int width = (image.width / cut).round();
      int height = (image.height / cut).round();

      List<imglib.Image> parts = <imglib.Image>[];
      for (int i = 0; i < cut; i++) {
        for (int j = 0; j < cut; j++) {
          parts.add(imglib.copyCrop(image, x, y, width, height));
          x += width;
        }
        x = 0;
        y += height;
      }

      // convert image from image package to Image Widget to display
      List<Model> output = [];
      for (var img in parts) {
        List<int>? imageWithHeader = imglib.encodeNamedImage(img, ".bmp");
        output.add(Model(
          index: output.length,
          widget: _getCanvas(
            MemoryImage(
              Uint8List.fromList(imageWithHeader!),
            ),
            size / cut,
          ),
        ));
      }

      return output;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
