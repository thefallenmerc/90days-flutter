class Resolution {
  String title;
  String description;
  String deadline;
  int completed;
  int userId;
  String updatedAt;
  String createdAt;
  int id;

  Resolution(
      {this.title,
      this.description,
      this.deadline,
      this.completed,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Resolution.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    deadline = json['deadline'];
    completed = json['completed'] is int
        ? json['completed']
        : int.parse(json['completed']);
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['completed'] = this.completed;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
