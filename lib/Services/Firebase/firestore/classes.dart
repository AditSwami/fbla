class UserData {
  UserData();
  UserData.empty();
  String id = "";
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
  DateTime dateMade = DateTime.now();
  String description = "";
  String name = "";
  Map<String, UnitData> units = {};
  List<String> members = [];
}

class UnitData {
  UnitData();
  String id = "";
  String name = "";
  String description = "";
  Map<TermData?, dynamic> terms = {};
}

class TermData {
  TermData();
  String termName = "";
  String defName = "";
  String termDataId = "";
}
