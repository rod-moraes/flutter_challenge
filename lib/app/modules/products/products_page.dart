import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/app/modules/products/states/products_get_state.dart';
import 'package:flutter_challenge/app/modules/products/widgets/alert_edit/alert_edit_widget.dart';
import 'package:flutter_challenge/app/shared/widgets/animation_remove_widget.dart';
import 'package:flutter_challenge/app/modules/products/widgets/product_tile/product_tile_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobx/mobx.dart';

import '../../domain/product/model/product_model.dart';
import '../../shared/widgets/snack_bar_widget.dart';
import 'products_store.dart';
import 'states/products_state.dart';
import 'widgets/alert_remove/alert_remove_widget.dart';
import 'widgets/slidable/slidable_card_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductsStore store = Modular.get<ProductsStore>();
  late GlobalKey<AnimatedListState> _listKey;
  late ReactionDisposer stateReaction;

  late ReactionDisposer stateGetReaction;

  @override
  void initState() {
    stateReaction = reaction((_) => store.state, (state) {
      if (state is ProductsStateSuccess) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBarWidget(false, state.message));
      } else if (state is ProductsStateFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBarWidget(true, state.message));
      }
    });

    stateGetReaction = reaction((_) => store.stateGet, (state) {
      if (state is ProductsGetStateSuccess) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBarWidget(false, state.message));
      } else if (state is ProductsGetStateFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBarWidget(true, state.message));
      }
    });

    store.getAllProducts();
    _listKey = GlobalKey<AnimatedListState>();
    super.initState();
  }

  @override
  void dispose() {
    stateReaction();
    stateGetReaction();
    super.dispose();
  }

  void deleteProduct(int index, Widget child) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertRemoveWidget(
        yesButton: () async {
          store.onRemoveProducts(index).then((isDeleted) {
            Navigator.pop(context);
            if (isDeleted) {
              AnimatedListRemovedItemBuilder builder;
              builder = (context, animation) =>
                  AnimationRemoveWidget(animation: animation, widget: child);
              _listKey.currentState!.removeItem(index, builder,
                  duration: const Duration(milliseconds: 300));
            }
          });
        },
      ),
    );
  }

  void editProduct(ProductModel product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertEditWidget(
        product: product,
        index: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hortifruti'),
      ),
      body: Observer(
        builder: (context) {
          if (store.stateGet is ProductsGetStateLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (store.stateGet is ProductsGetStateSuccess) {
            return SlidableAutoCloseBehavior(
              child: AnimatedList(
                padding: const EdgeInsets.only(top: 10),
                key: _listKey,
                initialItemCount: store.products.length,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index, animation) {
                  ProductModel product = store.products[index];
                  return Column(
                    children: [
                      SlidableCardWidget(
                        key: Key(product.hashCode.toString()),
                        onDelete: (widget) async {
                          deleteProduct(index, widget);
                        },
                        onEdit: () {
                          editProduct(product, index);
                        },
                        child: ProductTileWidget(
                          index: index,
                          product: product,
                          onEdit: () {
                            Future.delayed(const Duration(seconds: 0),
                                () => editProduct(product, index));
                          },
                          onDelete: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => deleteProduct(
                                index,
                                ProductTileWidget(
                                  index: index,
                                  product: product,
                                  onDelete: () {},
                                  onEdit: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8)
                    ],
                  );
                },
              ),
            );
          } else if (store.stateGet is ProductsGetStateFailure) {
            return Text((store.stateGet as ProductsGetStateFailure).message);
          }
          return Container();
        },
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   FirebaseFirestore firestore = FirebaseFirestore.instance;
      //   CollectionReference products =
      //       FirebaseFirestore.instance.collection('products');
      //   try {
      //     await Future.forEach(store.products, (product) {
      //       product as ProductModel;
      //       products.add(product.toMap());
      //     });
      //   } catch (e) {
      //     print(e);
      //   }
      // }),
    );
  }
}
