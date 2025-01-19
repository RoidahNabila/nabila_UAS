import 'package:vania/vania.dart';
import 'package:resep_masakan/app/http/controllers/customer_controller.dart';
import 'package:resep_masakan/app/http/controllers/products_controller.dart';
import 'package:resep_masakan/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');

    // Rute Customer
    Router.get("/customers", customerController.index);
    Router.post("/customers", customerController.store);
    Router.put("/customers", customerController.update);
    Router.delete("/customers", customerController.delete);
    Router.post("/customers/login", customerController.login);

    // Rute Products dengan middleware autentikasi
    Router.group(() {
      Router.get("/products", productsController.index);
      Router.post("/products", productsController.store);
      Router.put("/products", productsController.update);
      Router.delete("/products", productsController.delete);
    }, middleware: [AuthMiddleware()]);
  }
}
