import 'package:matrix/matrix.dart';

class MatrixService {
  static final MatrixService _instance = MatrixService._internal();
  factory MatrixService() => _instance;
  MatrixService._internal();

  late Client client;
  late Room room;

  Future<void> init(String username, String password, String homeserver) async {
    client = Client(
      'Bonga App',
      databaseBuilder: (_) => HiveCollectionsDatabase(),
    );
    await client.checkHomeserver(homeserver);
    await client.login(
      LoginType.mLoginPassword,
      identifier: AuthenticationUserIdentifier(user: username),
      password: password,
    );
    await client.start();
  }

  Future<void> joinRoom(String roomId) async {
    room = await client.getRoomById(roomId) ?? await client.joinRoom(roomId);
  }

  Future<void> sendMessage(String text) async {
    await room.sendTextEvent(text);
  }
}
