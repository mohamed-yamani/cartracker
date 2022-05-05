import 'package:hive/hive.dart';

part 'token.g.dart';

@HiveType(typeId: 3)
class TokenModel extends HiveObject {
  @HiveField(0)
  final String token;
  @HiveField(1)
  final String user;

  TokenModel(this.token, this.user);
}
