import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String UserName;
  @HiveField(1)
  final String Password;

  User(this.UserName, this.Password);
}
