import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrstock_app/service/warehouse_service.dart';
import 'location_screen.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  late Future<List<dynamic>> _warehousesFuture;

  @override
  void initState() {
    super.initState();
    _warehousesFuture = _fetchWarehouses();
  }

  Future<List<dynamic>> _fetchWarehouses() async {
    final response = await WarehouseService.getAllWarehouses();
    if (response["success"]) {
      return response["data"];
    } else {
      throw Exception("Lỗi: ${response['error']}");
    }
  }

  Future<void> _showCreateWarehouseDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController capacityController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tạo kho mới"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tên kho")),
            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Địa điểm")),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: "Sức chứa"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text;
              final location = locationController.text;
              final capacity = int.tryParse(capacityController.text) ?? 0;

              if (name.isNotEmpty && location.isNotEmpty && capacity > 0) {
                final response = await WarehouseService.createWarehouse(name, location, capacity);
                if (response["success"]) {
                  Navigator.pop(context);
                  setState(() {
                    _warehousesFuture = _fetchWarehouses();
                  });
                } else {
                  print("Lỗi tạo kho: ${response['error']}");
                }
              }
            },
            child: const Text("Tạo"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouses")),
      body: FutureBuilder<List<dynamic>>(
        future: _warehousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có kho nào."));
          }

          final warehouses = snapshot.data!;

          return ListView.builder(
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(warehouse["name"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("Location: ${warehouse['location']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info, color: Color.fromARGB(255, 158, 158, 158)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationScreen(warehouse: warehouse),
                            ),
                          );
                        },
                      ),
                      QrImageView(
                        data: warehouse["_id"],
                        size: 50,
                      ),
                    ],
                  ),
                  onTap: () => _showWarehouseDetails(warehouse),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateWarehouseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showWarehouseDetails(dynamic warehouse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(warehouse["name"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Location: ${warehouse['location']}"),
            Text("Capacity: ${warehouse['capacity']}"),
            const SizedBox(height: 10),
            QrImageView(data: warehouse["_id"], size: 100),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}