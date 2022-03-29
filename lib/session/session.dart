

abstract class Session {
  late String id;
  late String name, desc;
  late int time;
  abstract Map<String, List<String>> _exerciseInfo;

  Map<String, dynamic> toJson();
  void updateSession();
  void uploadSession();
  void removeSession();
  void addSessionFeedback();

  @override
  String toString() {
    return 'name: $name, time: $time, _exerciseInfo: '+ _exerciseInfo.length.toString();
  }
}