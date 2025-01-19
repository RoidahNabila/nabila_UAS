import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService apiService;
  String? token;
  bool isLoading = true;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    loadToken();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    if (token != null) {
      fetchProducts();
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await apiService.getProducts(token!);
      if (response['success']) {
        setState(() {
          products = response['data'];
        });
      } else {
        showError(response['message']);
      }
    } catch (e) {
      showError('Failed to fetch products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addProduct(String name, String price, String description) async {
    try {
      final response = await apiService.addProduct(token!, name, price, description);
      if (response['success']) {
        fetchProducts();
        showSuccess('Product added successfully!');
      } else {
        showError(response['message']);
      }
    } catch (e) {
      showError('Failed to add product: $e');
    }
  }

  Future<void> editProduct(int id, String name, String price, String description) async {
    try {
      final response = await apiService.updateProduct(token!, id, name, price, description);
      if (response['success']) {
        fetchProducts();
        showSuccess('Product updated successfully!');
      } else {
        showError(response['message']);
      }
    } catch (e) {
      showError('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiService.deleteProduct(token!, id);
      if (response['success']) {
        fetchProducts();
        showSuccess('Product deleted successfully!');
      } else {
        showError(response['message']);
      }
    } catch (e) {
      showError('Failed to delete product: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showProductDialog(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildProductListView(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 2) {
            logout();
          }
        },
      ),
    );
  }

  Widget buildProductListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(product['prod_name']),
          subtitle: Text(product['prod_desc']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => showProductDialog(
                  product: product,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteProduct(product['id']),
              ),
            ],
          ),
        );
      },
    );
  }

  void showProductDialog({Map<String, dynamic>? product}) {
    final TextEditingController nameController =
        TextEditingController(text: product?['prod_name'] ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?['prod_price']?.toString() ?? '');
    final TextEditingController descController =
        TextEditingController(text: product?['prod_desc'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Budget'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (product == null) {
                  addProduct(
                    nameController.text,
                    priceController.text,
                    descController.text,
                  );
                } else {
                  editProduct(
                    product['id'],
                    nameController.text,
                    priceController.text,
                    descController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
