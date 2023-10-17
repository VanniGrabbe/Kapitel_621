class ToDoItem {
  String title;
  bool isDone;

  ToDoItem({required this.title, this.isDone = false});

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'isDone': isDone,
    };
  }
  factory ToDoItem.fromJson(Map<String, dynamic> json){
    return ToDoItem(title: json['title'],isDone: json['isDone'],);
  }
}