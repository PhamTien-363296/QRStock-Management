import 'package:flutter/material.dart';
import '../service/product_service.dart';

class Productdetails extends StatefulWidget {
  final String warehouseId;
  final String locationId;
  final String? productId;

  const Productdetails({
    Key? key,
    required this.warehouseId,
    required this.locationId,
    this.productId,
  }) : super(key: key);

  @override
  _ProductdetailsState createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final result = await ProductService.getProductByWHLCPDId(
      widget.warehouseId,
      widget.locationId,
      productId: widget.productId,
    );

    if (result["success"]) {
      setState(() {
        products = result["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = result["error"];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách sản phẩm"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : products.isEmpty
                  ? const Center(child: Text("Không có sản phẩm nào."))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product["name"] ?? "Không có tên",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Mô tả: ${product["description"] ?? "Không có mô tả"}"),
            Text("Kho: ${product["warehouse_name"] ?? "Không xác định"}"),
            Text("Vị trí: Kệ ${product["location_shelf"]}, Ô ${product["location_bin"]}"),
            Text("Số lượng: ${product["quantity"] ?? 0}"),
            Text("Lô hàng: ${product["batch"] ?? "Không có thông tin"}"),
            Text("Ngày nhập: ${product["createdAt"] ?? "Không có thông tin"}"),
            if (product["qr_code"] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(
                  product["qr_code"],
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Text("Không thể tải QR code"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
