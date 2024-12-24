class UserData {
  UserData();

  UserData.empty();
  String firstName = "";
  String lastName = "";
  String pfp = "";
  String email = "";
  List<ClassData?> classes = [];
}

class ClassData {
  ClassData();
  String id = "";
  String creator = "";
  DateTime dateMade = "" as DateTime;
  String description = "";
  String name = "";
  List<UnitData?> units = [];
}

class UnitData {
  UnitData();
  String id = "";
  String name = "";
  String description = "";
}
