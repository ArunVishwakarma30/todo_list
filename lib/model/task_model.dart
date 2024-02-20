class Task {
  int? _id;
  String? _title;
  String? _description;
  int? _isCompleted;
  String? _dueDate;
  int? _priority;

  Task.withId(this._id, this._title, this._description, this._isCompleted,
      this._dueDate, this._priority);


  Task(this._title, this._description, this._isCompleted, this._dueDate,
      this._priority);

  int? get priority => _priority;

  set priority(int? value) {
    _priority = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  String? get dueDate => _dueDate;

  set dueDate(String? value) {
    _dueDate = value;
  }

  int? get isCompleted => _isCompleted;

  set isCompleted(int? value) {
    _isCompleted = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }

  // Convert a task object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['isCompleted'] = _isCompleted;
    map['priority'] = _priority;
    map['dueDate'] = _dueDate;
    return map;
  }

  // Extract a task object from a map
  Task.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _isCompleted = map['isCompleted'];
    _priority = map['priority'];
    _dueDate = map['dueDate'];
  }


}
