import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 2)
class MatchModel extends HiveObject {
  @HiveField(0)
  final String user;
  @HiveField(1)
  final String car;
  @HiveField(2)
  final String date;

  MatchModel(this.user, this.car, this.date);
}
