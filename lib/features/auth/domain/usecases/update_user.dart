import 'package:equatable/equatable.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';

class UpdateUser implements UseCaseWithParams<void, UpdateUserParams> {
  @override
  ResultFuture<void> call(UpdateUserParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userData});

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
