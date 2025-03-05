import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qrstock_app/login_screen.dart';
import 'api_service.dart';
// import 'create_product_screen.dart';

final Logger logger = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await ApiService.getProducts();
      if (response["success"] && response["data"] is List) {
        List<Map<String, dynamic>> loadedProducts = List<Map<String, dynamic>>.from(response["data"]);
        await Future.wait(loadedProducts.map((product) async {
          final inventoryResponse = await ApiService.getInventoryInfo(product["_id"]);
          product["inventory"] = inventoryResponse["success"] ? inventoryResponse["data"] : [];
        }));
        setState(() {
          products = loadedProducts;
        });
      } else {
        logger.e("Lỗi: ${response["error"]}");
      }
    } catch (e) {
      logger.e("Lỗi khi tải sản phẩm: $e");
    }
  }

  void _navigateToCreateProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (result == true) {
      fetchProducts();
    }
  }

  void _showAddInventoryDialog(String productId) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Inventory"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantity"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                int? quantity = int.tryParse(quantityController.text);
                String location = locationController.text.trim();

                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Quantity phải là số lớn hơn 0")),
                  );
                  return;
                }
                if (location.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Location không được để trống")),
                  );
                  return;
                }

                final result = await ApiService.addInventory(productId, quantity, location);
                Navigator.pop(context);

                if (result["success"]) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Inventory added successfully!")),
                  );
                  await fetchProducts(); // Cập nhật danh sách để ẩn nút
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi: ${result["error"]}")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Product List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return _productCard(products[index]);
                        },
                      ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToCreateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Create Product", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    try {
      Uint8List qrImage = base64Decode(product["qr_code"].split(",")[1]);
      final List<dynamic> inventory = product["inventory"] ?? [];

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Image.memory(qrImage, width: 50, height: 50),
          title: Text(product["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product["description"]),
              const SizedBox(height: 4),
              ...inventory.map((inv) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity: ${inv["quantity"]}", style: TextStyle(color: Colors.blue)),
                      Text("Location: ${inv["location"]}", style: TextStyle(color: Colors.blue)),
                      const SizedBox(height: 4),
                    ],
                  )),
            ],
          ),
          tileColor: Colors.grey[200],
          trailing: (inventory.isEmpty)
              ? ElevatedButton(
                  onPressed: () => _showAddInventoryDialog(product["_id"]),
                  child: const Text("Add Inventory"),
                )
              : null, // Ẩn nút nếu đã có inventory
        ),
      );
    } catch (e) {
      logger.e("Lỗi khi render product: $e");
      return const SizedBox.shrink();
    }
  }
}
