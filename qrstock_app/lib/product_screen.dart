import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'api_service.dart';

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
                  _fetchProducts(); // Cập nhật danh sách sản phẩm sau khi thêm
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
            const Text("Danh sách sản phẩm:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Text("Không có sản phẩm nào.", style: TextStyle(fontSize: 16))
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 card mỗi hàng
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2, // Điều chỉnh tỉ lệ chiều rộng & cao của thẻ
                              mainAxisExtent: 200, // Đặt chiều cao cố định cho card
                            ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(product: product);
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

// Widget để hiển thị từng sản phẩm dưới dạng card đẹp
class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4, // Độ nổi của card
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị QR Code từ _id
            Center(
              child: QrImageView(
                data: product["_id"], // Dữ liệu QR là ID của sản phẩm
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
            const SizedBox(height: 5),
            Text(
              product['description'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "#${product['_id'].toString().substring(0, 6)}", // Hiển thị ID ngắn gọn
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
