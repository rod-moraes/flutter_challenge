import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../products_store.dart';

class ImageCacheWidget extends StatelessWidget {
  final String pathFirebaseStorage;
  final double size;
  const ImageCacheWidget({
    Key? key,
    required this.pathFirebaseStorage,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsStore store = Modular.get<ProductsStore>();
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 10),
        child: FutureBuilder(
            future: store.getCachedImageFile(pathFirebaseStorage),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return const Icon(Icons.error);
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data is File) {
                return Image.file(
                  snapshot.data as File,
                  fit: BoxFit.cover,
                  errorBuilder: (context, url, error) =>
                      const Icon(Icons.error),
                );
              }
              return const Center(child: CircularProgressIndicator());
            })),
      ),
    );
  }
}
