import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_challenge/app/domain/product/model/product_model.dart';
import 'package:sizer/sizer.dart';

import 'image_cache_widget.dart';
import 'star_display_widget.dart';

class ProductTileWidget extends StatelessWidget {
  final ProductModel product;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ProductTileWidget({
    Key? key,
    required this.product,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double ratio = MediaQuery.of(context).size.aspectRatio / 10;
    double size = min(max(height, width) * 0.2, 200);
    if (max(height, width) * 0.2 > 140) ratio = 0;
    int lines = size ~/ (26 + ratio * 85);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        width: double.maxFinite,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            ImageCacheWidget(
              key: Key(product.id),
              pathFirebaseStorage: product.filename,
              size: size,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                      text: '${product.title}\n',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${product.type}\n',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: product.description,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ]),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: lines,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                              child: Icon(Icons.more_horiz),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Editar'),
                                    onTap: onEdit,
                                  ),
                                  PopupMenuItem(
                                    value: 'excluir',
                                    child: Text('Excluir'),
                                    onTap: () => onDelete(),
                                  ),
                                ];
                              })
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (width > size + 200)
                          StarDisplay(value: product.rating),
                        Text.rich(
                          TextSpan(
                              text: 'R\$',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: product.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
