import 'package:flutter/material.dart';
import 'package:logger/logger.dart';  
import 'api_service.dart'; 

class ProductScreen extends StatelessWidget {
  final dynamic location;
  final dynamic warehouse;

  // Khởi tạo logger
  final Logger logger = Logger();

  
      
  ProductScreen({super.key, required this.location, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm tại ${location['shelf']} - ${location['bin']}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Kho hàng: ${warehouse['name']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(" Địa chỉ: ${warehouse['location']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(" Vị trí: Kệ ${location['shelf']} - Ngăn ${location['bin']}", style: const TextStyle(fontSize: 18)),
            Text(" Sức chứa: ${location['max_capacity']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Mở hộp thoại để thêm sản phẩm
                await _showAddProductDialog(context, nameController, descriptionController);
              },
              child: const Text("Thêm Sản phẩm"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context, TextEditingController nameController, TextEditingController descriptionController) async {
  showDialog(
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

              
              if (warehouse['_id'] == null || location['_id'] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thông tin kho hàng hoặc vị trí không hợp lệ!')));
                  return;
                }

                

                
                final response = await ApiService.createProduct(
                  warehouse['_id'].toString(),  
                  location['_id'].toString(),  
                  name,
                  description,
                );


              if (response['success']) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sản phẩm đã được thêm thành công!')));
                Navigator.pop(context); // Đóng hộp thoại
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
  }
