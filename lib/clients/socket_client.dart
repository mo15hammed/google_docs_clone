import 'package:google_docs_clone/constants/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  late Socket socket;

  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io(
      ApiConstants.baseUrl,
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    socket.connect();
  }

  static SocketClient get instance => _instance ??= SocketClient._internal();
}
