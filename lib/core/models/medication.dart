class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final List<DateTime> scheduledTimes;
  final bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.startDate,
    this.endDate,
    required this.scheduledTimes,
    this.isActive = true,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      instructions: json['instructions'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      scheduledTimes: (json['scheduledTimes'] as List<dynamic>)
          .map((time) => DateTime.parse(time as String))
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'instructions': instructions,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'scheduledTimes': scheduledTimes.map((time) => time.toIso8601String()).toList(),
      'isActive': isActive,
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    String? instructions,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? scheduledTimes,
    bool? isActive,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      isActive: isActive ?? this.isActive,
    );
  }
} 