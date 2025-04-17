import 'package:firebase_auth/firebase_auth.dart';

enum UserType { patient, doctor }

class AppUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String address;
  final UserType userType;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalData;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.userType,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.additionalData,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      userType: json['userType'] == 'doctor' ? UserType.doctor : UserType.patient,
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      additionalData: json['additionalData'],
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      id: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      userType: data['userType'] == 'doctor' ? UserType.doctor : UserType.patient,
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt'] != null
          ? data['createdAt'] is DateTime
              ? data['createdAt']
              : DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? data['updatedAt'] is DateTime
              ? data['updatedAt']
              : DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      additionalData: data['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'userType': userType == UserType.doctor ? 'doctor' : 'patient',
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'userType': userType == UserType.doctor ? 'doctor' : 'patient',
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? address,
    UserType? userType,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalData,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

class Patient extends AppUser {
  final String? emergencyContact;
  final String? medicalHistory;
  final List<String>? allergies;
  final String? bloodType;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? height;
  final double? weight;

  Patient({
    required String id,
    required String email,
    required String name,
    required String phone,
    required String address,
    String? profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    Map<String, dynamic>? additionalData,
    this.emergencyContact,
    this.medicalHistory,
    this.allergies,
    this.bloodType,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.weight,
  }) : super(
          id: id,
          email: email,
          name: name,
          phone: phone,
          address: address,
          userType: UserType.patient,
          profileImageUrl: profileImageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
          additionalData: additionalData,
        );

  factory Patient.fromAppUser(AppUser user, {
    String? emergencyContact,
    String? medicalHistory,
    List<String>? allergies,
    String? bloodType,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
  }) {
    return Patient(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      address: user.address,
      profileImageUrl: user.profileImageUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      additionalData: user.additionalData,
      emergencyContact: emergencyContact,
      medicalHistory: medicalHistory,
      allergies: allergies,
      bloodType: bloodType,
      dateOfBirth: dateOfBirth,
      gender: gender,
      height: height,
      weight: weight,
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    final appUser = AppUser.fromJson(json);
    return Patient.fromAppUser(
      appUser,
      emergencyContact: json['emergencyContact'],
      medicalHistory: json['medicalHistory'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      bloodType: json['bloodType'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'bloodType': bloodType,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
    });
    return json;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'bloodType': bloodType,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
    });
    return map;
  }
}

class Doctor extends AppUser {
  final String? specialization;
  final String? licenseNumber;
  final String? hospital;
  final String? bio;
  final List<String>? certifications;
  final int? yearsOfExperience;
  final Map<String, dynamic>? availability;

  Doctor({
    required String id,
    required String email,
    required String name,
    required String phone,
    required String address,
    String? profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    Map<String, dynamic>? additionalData,
    this.specialization,
    this.licenseNumber,
    this.hospital,
    this.bio,
    this.certifications,
    this.yearsOfExperience,
    this.availability,
  }) : super(
          id: id,
          email: email,
          name: name,
          phone: phone,
          address: address,
          userType: UserType.doctor,
          profileImageUrl: profileImageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
          additionalData: additionalData,
        );

  factory Doctor.fromAppUser(AppUser user, {
    String? specialization,
    String? licenseNumber,
    String? hospital,
    String? bio,
    List<String>? certifications,
    int? yearsOfExperience,
    Map<String, dynamic>? availability,
  }) {
    return Doctor(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      address: user.address,
      profileImageUrl: user.profileImageUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      additionalData: user.additionalData,
      specialization: specialization,
      licenseNumber: licenseNumber,
      hospital: hospital,
      bio: bio,
      certifications: certifications,
      yearsOfExperience: yearsOfExperience,
      availability: availability,
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final appUser = AppUser.fromJson(json);
    return Doctor.fromAppUser(
      appUser,
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      hospital: json['hospital'],
      bio: json['bio'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      yearsOfExperience: json['yearsOfExperience'],
      availability: json['availability'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'hospital': hospital,
      'bio': bio,
      'certifications': certifications,
      'yearsOfExperience': yearsOfExperience,
      'availability': availability,
    });
    return json;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'hospital': hospital,
      'bio': bio,
      'certifications': certifications,
      'yearsOfExperience': yearsOfExperience,
      'availability': availability,
    });
    return map;
  }
}
