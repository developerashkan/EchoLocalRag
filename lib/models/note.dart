import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id()
  int id = 0;

  @Index()
  String title;

  String body;

  DateTime updatedAt;

  Note({
    this.id = 0,
    required this.title,
    required this.body,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
}
