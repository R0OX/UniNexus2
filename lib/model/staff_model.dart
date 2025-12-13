class Staff {
  final String id;
  final String fName;
  final String lName;
  final String pNum;
  final String email;
  final String pass;
  final String photo;
  final int workDays;
  final String type;

  Staff({
    required this.id,
    required this.fName,
    required this.lName,
    required this.pNum,
    required this.email,
    required this.pass,
    required this.photo,
    required this.workDays,
    required this.type,
  });

  // From JSON
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['ID'] ?? '',
      fName: json['fName'] ?? '',
      lName: json['lName'] ?? '',
      pNum: json['pNum'] ?? '',
      email: json['email'] ?? '',
      pass: json['pass'] ?? '',
      photo: json['photo'] ?? '',
      workDays: json['workDays'] ?? 0,
      type: json['type'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'fName': fName,
      'lName': lName,
      'pNum': pNum,
      'email': email,
      'pass': pass,
      'photo': photo,
      'workDays': workDays,
      'type': type,
    };
  }
}