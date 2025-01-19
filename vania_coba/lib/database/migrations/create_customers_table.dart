// lib/database/migrations/create_customers_table.dart
import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    // Membuat tabel 'customers' dengan kolom yang disederhanakan
    await createTableNotExists('customers', () {
      id(); // Auto-increment primary key
      string('cust_email', length: 50);
      string('cust_password', length: 100); // Untuk hash password
    });
  }

  @override
  Future<void> down() async {
    super.down();

    // Menghapus tabel 'customers' jika ada
    await dropIfExists('customers');
  }
}
