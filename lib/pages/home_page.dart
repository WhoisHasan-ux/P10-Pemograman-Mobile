import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../models/product_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

//membuat state untuk home page
  @override
  State<HomePage> createState() => _HomePageState();
}


//membuat class state untuk home page
class _HomePageState extends State<HomePage> {
  //inisialisasi variabel username
  String username = '';
  //Membuat vairiabel utama untuk menyimpan data
  List<ProductModel> products = [];

  //membuat init state untuk mengambil data username dari shared preferences
  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  //membuat method loadProducts untuk menampilkan daftar product
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productJsonList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productJsonList
      .map((item) => ProductModel.fromJson(item))
      .toList();
    }); 
  }

  
  //membuat method SaveProduct (untuk menyimpan perubahan produk)
  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productJsonList = products.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productJsonList);
  }



  //membuat method addProduct (untuk menambahkan produk baru)
  Future<void> addProduct(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      products.add(product);
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan')),
    );
  }


  //membuat method showDialog untuk menampilkan dialog form tambah produk
  void showForm(ProductModel? product, int? index) {
    //membuat controler
    TextEditingController nameController = TextEditingController(text: product?.name ?? '');
    TextEditingController descriptionController = TextEditingController(text: product?.description ?? '');
    TextEditingController priceController = TextEditingController(text: product?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () {
              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: int.tryParse(priceController.text) ?? 0,
              );
              if (product == null) {
                addProduct(newProduct);
              }else {
                editProduct(index!, newProduct);
              }
              Navigator.pop(context);
            },
          )
        ]
      )
    );
  }



  //membuat method editProduct (untuk mengedit produk yang sudah ada)
  Future<void> editProduct(int index, ProductModel updatedProduct) async {
    setState(() {
      products[index] = updatedProduct;
    });
    await saveProducts();
  }



  //membuat method deleteProduct (untuk menghapus produk)
  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil dihapus')),
    );
  }


  //membuat method getUser untuk mengambil data username dari shared preferences(lokal storage)
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }



  //Membuat method Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

//membuat widget builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(
            children: [
               Container(
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: const NetworkImage(
                        'https://picsum.photos/seed/picsum/536/354',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    228,
                                    231,
                                    233,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: logout,
                      child: Icon(
                        Icons.logout,
                        color: const Color.fromARGB(255, 200, 15, 15),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showForm(null, null),
                      child: Text("Tambah Produk"),
                    )
                  )
                ]
              ),
              SizedBox(height: 20),
              Expanded(
                child: products.isEmpty
                ? const Center(child: Text('Belum ada produk'))
                : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Harga: Rp ${product.price}'),
                            const SizedBox(height: 8),
                            Text(product.description),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             IconButton (
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showForm(product, index),
                            ),
                            IconButton (
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteProduct(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                )
              )
            ]
          )
        ),
      ),
    );
  }

}