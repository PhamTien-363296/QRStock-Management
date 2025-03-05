import 'package:flutter/material.dart';
import 'api_service.dart'; // Import ApiService

class LocationScreen extends StatefulWidget {
  final dynamic warehouse;

  const LocationScreen({super.key, required this.warehouse});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController shelfController = TextEditingController();
  final TextEditingController binController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  List<dynamic> locations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final warehouseId = widget.warehouse['_id'];
    final result = await ApiService.getLocationsByWarehouseId(warehouseId);

    if (result["success"]) {
      setState(() {
        locations = result["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${result['error']}")),
      );
    }
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: shelfController,
                decoration: const InputDecoration(labelText: "Kệ (Shelf)"),
              ),
              TextField(
                controller: binController,
                decoration: const InputDecoration(labelText: "Ngăn (Bin)"),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: "Sức chứa tối đa"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: _createLocation,
              child: const Text("Tạo"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createLocation() async {
    final warehouseId = widget.warehouse['_id'];
    final shelf = shelfController.text;
    final bin = binController.text;
    final maxCapacity = int.tryParse(capacityController.text) ?? 0;

    if (shelf.isEmpty || bin.isEmpty || maxCapacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin hợp lệ!")),
      );
      return;
    }

    final result = await ApiService.createLocation(warehouseId, shelf, bin, maxCapacity);

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thêm Location thành công!")),
      );
      Navigator.pop(context);
      _fetchLocations(); // Refresh danh sách location
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${result['error']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location: ${widget.warehouse['name']}")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Địa điểm: ${widget.warehouse['location']}", style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text("Sức chứa: ${widget.warehouse['capacity']}", style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: locations.isEmpty
                      ? const Center(child: Text("Không có location nào"))
                      : ListView.builder(
                          itemCount: locations.length,
                          itemBuilder: (context, index) {
                            final location = locations[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text("Kệ: ${location['shelf']} - Ngăn: ${location['bin']}"),
                                subtitle: Text("Sức chứa: ${location['max_capacity']}"),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showAddLocationDialog,
                  child: const Text("Thêm Location"),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
