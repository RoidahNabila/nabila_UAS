import 'package:vania/vania.dart';
import 'package:mysql1/mysql1.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../../database/database_connection.dart';
import '../../../utils/token_utils.dart';

class CustomerController extends Controller {
  // Tampilkan semua customer
  Future<Response> index() async {
    try {
      MySqlConnection conn = await connectToDatabase();
      var results = await conn.query('SELECT id, cust_email FROM customers');
      await conn.close();

      return Response.json({
        'data': results
            .map((row) => {
                  'id': row['id'],
                  'cust_email': row['cust_email'],
                })
            .toList()
      });
    } catch (e) {
      return Response.json({
        'error': 'Gagal mengambil data customer',
        'message': e.toString()
      }).status(500);
    }
  }

  // Tambah customer baru
  Future<Response> store(Request request) async {
    try {
      final body = request.input();

      MySqlConnection conn = await connectToDatabase();

      // Hash password sebelum disimpan
      final hashedPassword =
          sha256.convert(utf8.encode(body['cust_password'])).toString();

      // Menjalankan query untuk menambahkan customer
      var result = await conn.query(
          'INSERT INTO customers (cust_email, cust_password) VALUES (?, ?)', [
        body['cust_email'],
        hashedPassword,
      ]);

      await conn.close();

      if (result.insertId != null) {
        return Response.json({'message': 'Customer added successfully!'}, 201);
      } else {
        return Response.json({'error': 'Failed to add customer.'}, 500);
      }
    } catch (e) {
      return Response.json({
        'error': 'Gagal menambah data customer',
        'message': e.toString(),
      }, 500);
    }
  }

  // Update customer
  Future<Response> update(Request request) async {
    try {
      final id = request.query('id');

      if (id == null) {
        return Response.json({'error': 'id is required'}, 400);
      }

      final body = request.input();
      MySqlConnection conn = await connectToDatabase();

      // Cek apakah customer dengan id ini ada
      var result =
          await conn.query('SELECT * FROM customers WHERE id = ?', [id]);

      if (result.isEmpty) {
        return Response.json({'error': 'Customer not found'}, 404);
      }

      // Hash password jika ada perubahan
      final hashedPassword = body['cust_password'] != null
          ? sha256.convert(utf8.encode(body['cust_password'])).toString()
          : null;

      // Update customer
      await conn.query(
          'UPDATE customers SET cust_email = ?, cust_password = IFNULL(?, cust_password) WHERE id = ?',
          [
            body['cust_email'],
            hashedPassword,
            id,
          ]);

      await conn.close();
      return Response.json({'message': 'Customer updated successfully!'}, 200);
    } catch (e) {
      return Response.json({
        'error': 'Failed to update customer',
        'message': e.toString(),
      }, 500);
    }
  }

  // Hapus customer
  Future<Response> delete(Request request) async {
    try {
      final id = request.query('id');

      if (id == null) {
        return Response.json({'error': 'id is required'}, 400);
      }

      MySqlConnection conn = await connectToDatabase();

      // Cek apakah customer dengan id ini ada
      var result =
          await conn.query('SELECT * FROM customers WHERE id = ?', [id]);

      if (result.isEmpty) {
        return Response.json({'error': 'Customer not found'}, 404);
      }

      // Hapus customer berdasarkan id
      await conn.query('DELETE FROM customers WHERE id = ?', [id]);

      await conn.close();

      return Response.json({'message': 'Customer deleted successfully!'}, 200);
    } catch (e) {
      return Response.json({
        'error': 'Gagal menghapus data customer',
        'message': e.toString(),
      }, 500);
    }
  }

  // Fungsi Login
  Future<Response> login(Request request) async {
    try {
      final body = request.input();
      final email = body['cust_email'];
      final password = body['cust_password'];

      if (email == null || password == null) {
        return Response.json({'error': 'Email and password are required'}, 400);
      }

      MySqlConnection conn = await connectToDatabase();

      // Validasi user berdasarkan email
      var result = await conn.query(
          'SELECT id, cust_password FROM customers WHERE cust_email = ?',
          [email]);

      if (result.isEmpty) {
        return Response.json({'error': 'Invalid credentials'}, 401);
      }

      final row = result.first;
      final int id =
          row['id']; // Pastikan tipe data sesuai dengan kolom di database
      final String hashedPassword = row['cust_password'];

      // Cek password
      final inputPasswordHash =
          sha256.convert(utf8.encode(password)).toString();
      if (hashedPassword != inputPasswordHash) {
        return Response.json({'error': 'Invalid credentials'}, 401);
      }

      // Generate token (konversi id ke string jika dibutuhkan oleh token)
      final token = generateToken(id.toString());
      await conn.close();

      return Response.json({'access_token': token});
    } catch (e) {
      return Response.json(
          {'error': 'Failed to login', 'message': e.toString()}, 500);
    }
  }
}

final customerController = CustomerController();
