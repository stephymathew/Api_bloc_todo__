class TodoModel {
    String? id;
    String title;
    String description;
    bool? isCompleted;
    DateTime? createdAt;
    DateTime? updatedAt;

    TodoModel({
         this.id,
        required this.title,
        required this.description,
         this.isCompleted,
         this.createdAt,
         this.updatedAt,
    });




  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        
        id: json['_id'],
        title: json['title'],
        description: json['description']);
  }
}
