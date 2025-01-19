import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.24:8000/api'; // Sesuaikan URL backend Anda

  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/customers');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cust_email': email,
          'cust_password': password,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['error']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Failed to register: $e'};
    }
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/customers/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cust_email': email,
        'cust_password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {'success': true, 'access_token': responseData['access_token']};
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['error']};
    }
  } catch (e) {
    return {'success': false, 'message': 'Failed to login: $e'};
  }
}

Future<Map<String, dynamic>> getProducts(String token) async {
  final url = Uri.parse('$baseUrl/products');
  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {'success': true, 'data': responseData['data']};
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['error']};
    }
  } catch (e) {
    return {'success': false, 'message': 'Failed to fetch products: $e'};
  }
}

Future<Map<String, dynamic>> addProduct(
    String token, String name, String price, String description) async {
  final url = Uri.parse('$baseUrl/products');
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prod_name': name,
        'prod_price': price,
        'prod_desc': description,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['error']};
    }
  } catch (e) {
    return {'success': false, 'message': 'Failed to add product: $e'};
  }
}

Future<Map<String, dynamic>> updateProduct(
    String token, int id, String name, String price, String description) async {
  final url = Uri.parse('$baseUrl/products?id=$id');
  try {
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prod_name': name,
        'prod_price': price,
        'prod_desc': description,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['error']};
    }
  } catch (e) {
    return {'success': false, 'message': 'Failed to update product: $e'};
  }
}
Future<Map<String, dynamic>> deleteProduct(String token, int id) async {
  final url = Uri.parse('$baseUrl/products?id=$id');
  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['error']};
    }
  } catch (e) {
    return {'success': false, 'message': 'Failed to delete product: $e'};
  }
}

}
