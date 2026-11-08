class PersonalRecordModel {
  final String exerciseName;
  final String record;
  final String date;

  const PersonalRecordModel({
    required this.exerciseName,
    required this.record,
    required this.date,
  });
}

class ProgressStatModel {
  final List<double> weeklyVolume; // 7 days Mon-Sun
  final List<String> weekDays;
  final List<double> weightProgression;
  final List<String> weightDates;
  final List<PersonalRecordModel> personalRecords;

  const ProgressStatModel({
    required this.weeklyVolume,
    required this.weekDays,
    required this.weightProgression,
    required this.weightDates,
    required this.personalRecords,
  });
}

