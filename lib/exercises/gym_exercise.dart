import 'package:achieve/exercises/exercise.dart';

class GymExercise extends Exercise {
  @override
  String description;
  @override
  String id;
  @override
  String name;
  @override
  String type;
  @override
  String url;

  GymExercise(this.description, this.id, this.name, this.type, this.url);

  factory GymExercise.fromJson(dynamic json) => _fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'url': url,
      };
}

GymExercise _fromJson(dynamic json) {
  return GymExercise(
      json['description'], json['id'], json['name'], json['type'], json['url']);
}
