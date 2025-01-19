import 'package:vania/vania.dart';
import 'package:mysql1/mysql1.dart';
import '../../../database/database_connection.dart';
import '../../../utils/token_utils.dart';

class ProductsController extends Controller {
  Future<bool> checkTokenValidity(Request req) async {
    final token = req.header('Authorization')?.replaceFirst('Bearer ', '');
    print("Token Received: $token");

    if (token == null || !validateToken(token)) {
      print("Invalid token");
      return false;
    }

    return true;
  }

  // Tampilkan semua produk
  Future<Response> index(Request req) async {
    if (!(await checkTokenValidity(req))) {
      return Response.json({'error': 'Unauthorized'}, 401);
    }

    try {
      MySqlConnection conn = await connectToDatabase();
      var results = await conn.query('SELECT * FROM products');
      await conn.close();

      // Konversi hasil query ke dalam daftar map dengan penanganan tipe data
      final data = results.map((row) {
        return {
          'id': row['id'],
          'prod_name': row['prod_name'],
          'prod_price': row['prod_price'],
          'prod_desc':
              row['prod_desc'].toString(), // Konversi Blob/Text ke String
        };
      }).toList();

      // Kembalikan hasil JSON dengan format valid
      return Response.json({'data': data});
    } catch (e) {
      return Response.json(
          {'error': 'Failed to fetch products', 'message': e.toString()}, 500);
    }
  }

  // Tambah produk baru
  Future<Response> store(Request req) async {
    if (!(await checkTokenValidity(req))) {
      return Response.json({'error': 'Unauthorized'}, 401);
    }

    final body = req.input();
    try {
      MySqlConnection conn = await connectToDatabase();

      // Tambahkan produk baru
      var result = await conn.query(
          'INSERT INTO products (prod_name, prod_price, prod_desc) VALUES (?, ?, ?)',
          [body['prod_name'], body['prod_price'], body['prod_desc']]);
      await conn.close();

      if (result.insertId != null) {
        return Response.json({'message': 'Product added successfully!'}, 201);
      } else {
        return Response.json({'error': 'Failed to add product.'}, 500);
      }
    } catch (e) {
      return Response.json(
          {'error': 'Failed to add product', 'message': e.toString()}, 500);
    }
  }

  // Update produk
  Future<Response> update(Request req) async {
    if (!(await checkTokenValidity(req))) {
      return Response.json({'error': 'Unauthorized'}, 401);
    }

    final body = req.input();
    final id = req.query('id'); // Menggunakan id sebagai parameter

    if (id == null || id.isEmpty) {
      return Response.json({'error': 'id is required'}, 400);
    }

    try {
      MySqlConnection conn = await connectToDatabase();
      await conn.query(
          'UPDATE products SET prod_name = ?, prod_price = ?, prod_desc = ? WHERE id = ?',
          [body['prod_name'], body['prod_price'], body['prod_desc'], id]);
      await conn.close();

      return Response.json({'message': 'Product updated successfully!'}, 200);
    } catch (e) {
      return Response.json(
          {'error': 'Failed to update product', 'message': e.toString()}, 500);
    }
  }

  // Hapus produk
  Future<Response> delete(Request req) async {
    if (!(await checkTokenValidity(req))) {
      return Response.json({'error': 'Unauthorized'}, 401);
    }

    final id = req.query('id'); // Hapus berdasarkan id

    if (id == null || id.isEmpty) {
      return Response.json({'error': 'id is required'}, 400);
    }

    try {
      MySqlConnection conn = await connectToDatabase();
      await conn.query('DELETE FROM products WHERE id = ?', [id]);
      await conn.close();

      return Response.json({'message': 'Product deleted successfully!'}, 200);
    } catch (e) {
      return Response.json(
          {'error': 'Failed to delete product', 'message': e.toString()}, 500);
    }
  }
}

final productsController = ProductsController();
