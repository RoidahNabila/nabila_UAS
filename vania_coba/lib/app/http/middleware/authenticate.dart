import 'package:vania/vania.dart';
import '../../../utils/token_utils.dart';

class AuthMiddleware extends Middleware {
  @override
  Future<Response?> handle(Request req) async {
    final token = req.header('Authorization')?.replaceFirst('Bearer ', '');
    print("Token Received: $token");

    // Periksa apakah token ada
    if (token == null) {
      print("No token provided");
      return Response.json({'error': 'Unauthorized: No token provided'}, 401);
    }

    // Validasi token
    if (!validateToken(token)) {
      print("Invalid token");
      return Response.json({'error': 'Unauthorized: Invalid token'}, 401);
    }

    try {
      // Decode token dan ambil payload
      final payload = decodeToken(token);
      print("Decoded Payload: $payload");

      // Validasi id
      final tokenId = payload['id'];
      final requestId = req.query('id');

      if (tokenId == null || tokenId != requestId) {
        print("id mismatch: tokenId=$tokenId, requestId=$requestId");
        return Response.json({'error': 'Unauthorized: id mismatch'}, 401);
      }

      print("Token and id validated successfully");
      return null; // Lanjutkan ke handler berikutnya
    } catch (e) {
      print("Error decoding token: $e");
      return Response.json(
          {'error': 'Unauthorized: Token decoding failed'}, 401);
    }
  }
}
