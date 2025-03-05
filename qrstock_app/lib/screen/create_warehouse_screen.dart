import 'package:flutter/material.dart';
import 'package:qrstock_app/service/warehouse_service.dart';

class CreateWarehouseScreen extends StatefulWidget {
  const CreateWarehouseScreen({super.key});

  @override
  _CreateWarehouseScreenState createState() => _CreateWarehouseScreenState();
}

class _CreateWarehouseScreenState extends State<CreateWarehouseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createWarehouse() async {
    final name = _nameController.text;
    final location = _locationController.text;
    final capacity = int.tryParse(_capacityController.text) ?? 0;

    if (name.isEmpty || location.isEmpty || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin hợp lệ!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await WarehouseService.createWarehouse(name, location, capacity);

    setState(() {
      _isLoading = false;
    });

    if (response["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo kho thành công!")),
      );
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["error"] ?? "Lỗi khi tạo kho!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo Warehouse")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên kho"),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Địa điểm"),
            ),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: "Sức chứa"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createWarehouse,
                    child: const Text("Tạo Warehouse"),
                  ),
          ],
        ),
      ),
    );
  }
}
