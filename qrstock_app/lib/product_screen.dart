import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'api_service.dart';
import 'dart:convert';


class ProductScreen extends StatefulWidget {
  final dynamic location;
  final dynamic warehouse;

  ProductScreen({super.key, required this.location, required this.warehouse});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final Logger logger = Logger();
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await ApiService.getProductsByWarehouseAndLocation(
      widget.warehouse['_id'].toString(),
      widget.location['_id'].toString(),
    );

    if (response['success']) {
      setState(() {
        products = response['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
    }
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm Sản phẩm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả sản phẩm'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text;
                String description = descriptionController.text;

                if (name.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')));
                  return;
                }

                final response = await ApiService.createProduct(
                  widget.warehouse['_id'].toString(),
                  widget.location['_id'].toString(),
                  name,
                  description,
                );

                if (response['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sản phẩm đã được thêm thành công!')));
                  Navigator.pop(context);
                  _fetchProducts(); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm tại ${widget.location['shelf']} - ${widget.location['bin']}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kho hàng: ${widget.warehouse['name']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Địa chỉ: ${widget.warehouse['location']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Vị trí: Kệ ${widget.location['shelf']} - Ngăn ${widget.location['bin']}", style: const TextStyle(fontSize: 18)),
            Text("Sức chứa: ${widget.location['max_capacity']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _showAddProductDialog(context);
              },
              child: const Text("Thêm Sản phẩm"),
            ),
            const SizedBox(height: 20),
            const Text("Danh sách sản phẩm:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Text("Không có sản phẩm nào.", style: TextStyle(fontSize: 16))
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2,
                            mainAxisExtent: 230, 
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              warehouseId: widget.warehouse['_id'],
                              locationId: widget.location['_id'],
                              onInventoryUpdated: _fetchProducts, 
                            );
                          },
                        ),
                      ),

          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  final String warehouseId;
  final String locationId;
  final VoidCallback onInventoryUpdated;

  const ProductCard({
    super.key,
    required this.product,
    required this.warehouseId,
    required this.locationId,
    required this.onInventoryUpdated,
  });

  void _showAddInventoryDialog(BuildContext context) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController batchController = TextEditingController();
    DateTime? expiryDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm tồn kho - ${product['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Số lượng"),
              ),
              TextField(
                controller: batchController,
                decoration: const InputDecoration(labelText: "Số Batch"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      expiryDate == null
                          ? "Chọn ngày hết hạn"
                          : "HSD: ${expiryDate!.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        expiryDate = pickedDate;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                int? quantity = int.tryParse(quantityController.text);
                String batch = batchController.text.trim();

                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng nhập số lượng hợp lệ!")),
                  );
                  return;
                }

                if (batch.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng nhập Số Batch!")),
                  );
                  return;
                }

                if (expiryDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng chọn Ngày hết hạn!")),
                  );
                  return;
                }

                final response = await ApiService.addInventory(
                  product["_id"],
                  warehouseId,
                  locationId,
                  quantity,
                  batch,
                  expiryDate!.toIso8601String(),
                );

                if (response["success"]) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thêm tồn kho thành công!")),
                  );
                  onInventoryUpdated(); // Refresh danh sách
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response["error"] ?? "Lỗi khi thêm inventory")),
                  );
                }
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: QrImageView(
                data: jsonEncode({"name": product["name"], "id": product["_id"]}),
                size: 100,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product['name'],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product['description'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${product['_id'].toString().substring(0, 6)}",
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () => _showAddInventoryDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


