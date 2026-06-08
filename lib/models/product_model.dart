import 'dart:convert';

class ProductModel {
  //inisialisasi variabel data
  final String name;
  final String description;
  final int price;

//menambakan konstruktor untuk menginisialisasi data
  ProductModel({ required this.name, required this.description, required this.price,});

  //OBJEK -> MAP jSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  //MAP JSON -> OBJEK
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toInt() ?? 0,//untuk mengubah data price menjadi integer
    );
  }

  //OBJEK -> STRING JSON
  String toJson() => json.encode(toMap());

  // JSON STRING -> OBJEK
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(
      json.decode(source));
  }
}

