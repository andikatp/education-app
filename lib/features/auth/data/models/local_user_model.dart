import 'dart:convert';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.bio,
    super.enrolledCourseIds,
    super.followers,
    super.following,
    super.groupIds,
    super.profilePic,
  });

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          profilePic: map['profilePic'] as String?,
          bio: map['bio'] as String?,
          points: (map['points'] as num).toInt(),
          fullName: map['fullName'] as String,
          groupIds: List<String>.from(map['groupIds'] as List<dynamic>),
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          following: List<String>.from(map['following'] as List<dynamic>),
          followers: List<String>.from(map['followers'] as List<dynamic>),
        );

  const LocalUserModel.empty() : super.empty();

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'bio': bio,
      'points': points,
      'fullName': fullName,
      'groupIds': groupIds,
      'enrolledCourseIds': enrolledCourseIds,
      'following': following,
      'followers': followers,
    };
  }

  String toJson() => json.encode(toMap());
}
