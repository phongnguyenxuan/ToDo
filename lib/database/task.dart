class Task {
  int? id;
  String? title;
  String? task;
  int? isCompleted;
  String? date;
  String? time;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.task,
    this.isCompleted,
    this.date,
    this.time,
    this.remind,
    this.repeat,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    task = json["task"];
    isCompleted = json["isCompleted"];
    date = json["date"];
    time = json["time"];
    remind = json["remind"];
    repeat = json["repeat"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["title"] = title;
    data["task"] = task;
    data["isCompleted"] = isCompleted;
    data["date"] = date;
    data["time"] = time;
    data["remind"] = remind;
    data["repeat"] = repeat;
    return data;
  }
}
