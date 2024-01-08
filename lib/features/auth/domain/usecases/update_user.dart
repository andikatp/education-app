import 'package:equatable/equatable.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';

class UpdateUser implements UseCaseWithParams<void, UpdateUserParams> {
  const UpdateUser({required AuthRepository repository})
      : _repository = repository;
  final AuthRepository _repository;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repository.updateUser(
        action: params.action,
        userData: params.userData,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userData});

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
