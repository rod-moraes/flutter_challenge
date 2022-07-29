import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_challenge/app/domain/product/model/product_model.dart';

import '../../products_store.dart';
import '../product_tile/image_cache_widget.dart';
import 'star_button_widget.dart';

class AlertEditWidget extends StatefulWidget {
  final ProductModel product;
  final int index;
  const AlertEditWidget({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  @override
  State<AlertEditWidget> createState() => _AlertEditWidgetState();
}

class _AlertEditWidgetState extends State<AlertEditWidget> {
  final ProductsStore store = Modular.get<ProductsStore>();
  final _formKey = GlobalKey<FormState>();
  final scrollTextForm = ScrollController();
  late Widget image;
  late MoneyMaskedTextController moneyController;

  bool isLoad = false;
  String? title;
  String? type;
  String? description;
  double? price;
  int? rating;

  @override
  void initState() {
    moneyController = MoneyMaskedTextController(
      leftSymbol: 'R\$ ',
      initialValue: widget.product.price,
    );
    image = ImageCacheWidget(
      size: 50.w,
      pathFirebaseStorage: widget.product.filename,
    );
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    scrollTextForm.dispose();
    moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edição de produto"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              StarButtonWidget(
                initValue: widget.product.rating,
                enable: !isLoad,
                onChanged: (value) {
                  rating = value;
                },
              ),
              TextFormField(
                initialValue: widget.product.title,
                enabled: !isLoad,
                onSaved: (value) {
                  title = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo é obrigatório!";
                  }
                },
                decoration: const InputDecoration(
                  label: Text("Titulo"),
                  hintText: "Digite aqui o titulo do seu produto",
                ),
              ),
              TextFormField(
                initialValue: widget.product.type,
                enabled: !isLoad,
                onSaved: (value) {
                  type = value;
                },
                decoration: const InputDecoration(
                  label: Text("Tipo"),
                  hintText: "Digite aqui o tipo do seu produto",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo é obrigatório!";
                  }
                },
              ),
              TextFormField(
                controller: moneyController,
                enabled: !isLoad,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = moneyController.numberValue;
                },
                decoration: const InputDecoration(
                  label: Text("Preço"),
                  hintText: "Digite aqui o preço do seu produto",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo é obrigatório!";
                  }
                },
              ),
              TextFormField(
                scrollController: scrollTextForm,
                enabled: !isLoad,
                initialValue: widget.product.description,
                onSaved: (value) {
                  description = value;
                },
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  label: Text("Descrição"),
                  hintText: "Digite aqui a descrição do seu produto",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (isLoad) ...[
          CircularProgressIndicator(),
          SizedBox(width: 8),
        ] else ...[
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ProductModel productSend = widget.product.copyWith(
                    title: title,
                    type: type,
                    description: description,
                    price: price,
                    rating: rating,
                  );
                  isLoad = true;
                  setState(() {});
                  //await Future.delayed(Duration(seconds: 4));
                  store.onEditProduct(productSend, widget.index).then((value) {
                    if (value) {
                      Navigator.pop(context);
                    } else {
                      isLoad = false;
                      setState(() {});
                    }
                  });
                }
              },
              child: Text("Editar")),
        ],
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
      ],
    );
  }
}
