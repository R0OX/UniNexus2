class ScheduleModel {
  List<String> periods;
  String day;
  String faculty;
  String year;
  String section;

  ScheduleModel({
    required this.periods,
    required this.day,
    required this.faculty,
    required this.year,
    required this.section,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      periods: [
        json['9:00-9:50'] ?? '',   // Index 0
        json['9:50-10:40'] ?? '',  // Index 1
        json['10:50-11:40'] ?? '', // Index 2
        json['11:40-12:30'] ?? '', // Index 3
        json['1:00-1:50'] ?? '',   // Index 4
        json['1:50-2:40'] ?? '',   // Index 5
        json['2:50-3:40'] ?? '',   // Index 6
        json['3:40-4:30'] ?? '',   // Index 7
        json['4:30-5:20'] ?? '',   // Index 8
        json['5:20-6:10'] ?? '',   // Index 9
      ],
      day: json['day'] ?? '',
      faculty: json['faculty'] ?? '',
      year: json['year']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
    );
  }
}