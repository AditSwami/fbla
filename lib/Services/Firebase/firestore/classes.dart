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
  String creator_id = "";
  DateTime dateMade = DateTime.now();
  String description = "";
  String name = "";
  Map<String, UnitData> units = {};
  List<dynamic> members = [];
}

class UnitData {
  UnitData();
  String id = "";
  String name = "";
  String description = "";
  Map<String, dynamic> terms = {};
  int testScore = 0;  // Single test score as integer
  
  double get score {
    return testScore.toDouble();
  }
}

class PostData{
  PostData(){
    date = DateTime.now().millisecondsSinceEpoch;
  }
  String uid = "";
  String id = "";
  String title = "";
  String type = "Competition";
  int date = 0;
  String description = "";
  List<String> pics = [];
  List<String> likes = [];
  List<CommentData> comments = [];

  UserData user = UserData();
}

class CommentData{
  String content = "";
  String uid = "";
  String id = "";
  int time = 0;
  List<String> likes = [];
  List<ReplyData> replies = [];
}

class ReplyData{
  String content = "";
  String uid = "";
  String id = "";
  int time = 0;
  List<String> likes = [];
}


