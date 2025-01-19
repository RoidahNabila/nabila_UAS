import 'package:vania/vania.dart';
import 'package:resep_masakan/route/api_route.dart';
import 'package:resep_masakan/route/web.dart';
import 'package:resep_masakan/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}
