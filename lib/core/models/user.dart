import 'package:firebase_auth/firebase_auth.dart';

enum UserType { patient, doctor }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? phoneNumber;
  final String? photoUrl;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalData;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phoneNumber,
    this.photoUrl,
    this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.additionalData,
  }) : this.createdAt = createdAt ?? DateTime.now(),
       this.updatedAt = updatedAt ?? DateTime.now();

  factory AppUser.fromMap(Map<String, dynamic> map) {
    // Improved user type handling
    UserType userType;
    final userTypeStr = map['userType'];
    
    if (userTypeStr is String) {
      // Handle both formats: "doctor" and "UserType.doctor"
      final normalizedType = userTypeStr.contains('.') 
          ? userTypeStr.split('.').last.toLowerCase()
          : userTypeStr.toLowerCase();
          
      userType = normalizedType == 'doctor' ? UserType.doctor : UserType.patient;
      print('User.fromMap - Parsed userType: $normalizedType to $userType');
    } else {
      userType = UserType.patient;
      print('User.fromMap - Using default userType: $userType');
    }
    
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      userType: userType,
      phoneNumber: map['phoneNumber'] as String?,
      photoUrl: map['photoUrl'] as String?,
      address: map['address'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalData': additionalData,
    };
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
    required String name,
    required String email,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
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
          name: name,
          email: email,
          userType: UserType.patient,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          address: address,
          createdAt: createdAt,
          updatedAt: updatedAt,
          additionalData: additionalData,
        );

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      address: map['address'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
      emergencyContact: map['emergencyContact'] as String?,
      medicalHistory: map['medicalHistory'] as String?,
      allergies: map['allergies'] != null ? List<String>.from(map['allergies']) : null,
      bloodType: map['bloodType'] as String?,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      gender: map['gender'] as String?,
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
    );
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
    required String name,
    required String email,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
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
          name: name,
          email: email,
          userType: UserType.doctor,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          address: address,
          createdAt: createdAt,
          updatedAt: updatedAt,
          additionalData: additionalData,
        );

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      address: map['address'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
      specialization: map['specialization'] as String?,
      licenseNumber: map['licenseNumber'] as String?,
      hospital: map['hospital'] as String?,
      bio: map['bio'] as String?,
      certifications: map['certifications'] != null ? List<String>.from(map['certifications']) : null,
      yearsOfExperience: map['yearsOfExperience'] as int?,
      availability: map['availability'] as Map<String, dynamic>?,
    );
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
