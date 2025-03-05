import 'package:flutter/material.dart';
import 'api_service.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? qrCode;
  bool _isLoading = false;

  void _createProduct() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.createProduct(
      nameController.text,
      descriptionController.text,
    );

    setState(() {
      _isLoading = false;
      if (result["success"]) {
        qrCode = result["data"]["qr_code"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Product Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createProduct,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Create"),
            ),
            if (qrCode != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(qrCode!),
              ),
          ],
        ),
      ),
    );
  }
}
