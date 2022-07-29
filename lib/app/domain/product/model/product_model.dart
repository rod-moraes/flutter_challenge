import 'dart:convert';

class ProductModel {
  final String id;
  final String title;
  final String type;
  final String description;
  final String filename;
  final int height;
  final int width;
  final double price;
  final int rating;
  ProductModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.filename,
    required this.height,
    required this.width,
    required this.price,
    required this.rating,
  });

  ProductModel copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
    String? filename,
    int? height,
    int? width,
    double? price,
    int? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      filename: filename ?? this.filename,
      height: height ?? this.height,
      width: width ?? this.width,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'filename': filename,
      'height': height,
      'width': width,
      'price': price,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      filename: map['filename'] ?? '',
      height: map['height']?.toInt() ?? 0,
      width: map['width']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      rating: map['rating']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  static List<ProductModel> listFromJson(String source) {
    List<dynamic> list = json.decode(source);
    return list.map((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, type: $type, description: $description, filename: $filename, height: $height, width: $width, price: $price, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.title == title &&
        other.type == type &&
        other.description == description &&
        other.filename == filename &&
        other.height == height &&
        other.width == width &&
        other.price == price &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        description.hashCode ^
        filename.hashCode ^
        height.hashCode ^
        width.hashCode ^
        price.hashCode ^
        rating.hashCode;
  }
}
