// lib/database/migrations/create_products_table.dart
import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    // Membuat tabel products jika belum ada
    await createTableNotExists('products', () {
      id(); // Auto-increment primary key
      string('prod_name', length: 50);
      integer('prod_price');
      text('prod_desc');
    });
  }

  @override
  Future<void> down() async {
    super.down();

    // Menghapus tabel products jika ada
    await dropIfExists('products');
  }
}
