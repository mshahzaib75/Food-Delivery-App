// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  String image;
  String name;
  String range;
  String id;
  Product({
    required this.image,
    required this.name,
    required this.range,
    required this.id,
  });

  Product copyWith({
    String? image,
    String? name,
    String? range,
    String? id,
  }) {
    return Product(
      image: image ?? this.image,
      name: name ?? this.name,
      range: range ?? this.range,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'range': range,
      'id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      image: map['image'] as String,
      name: map['name'] as String,
      range: map['range'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(image: $image, name: $name, range: $range, id: $id)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image &&
      other.name == name &&
      other.range == range &&
      other.id == id;
  }

  @override
  int get hashCode {
    return image.hashCode ^
      name.hashCode ^
      range.hashCode ^
      id.hashCode;
  }
}
