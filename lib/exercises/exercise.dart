

abstract class Exercise{
  abstract String id;
  abstract String name, description, type, url;
  Map<String, dynamic> toJson();
}