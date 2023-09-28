part of 'api_cubit.dart';

class ApiState {}

class PostInitial extends ApiState {}

class PostLoading extends ApiState {}

class PostLoaded extends ApiState {
  List<PostDeatils> postList;

  PostLoaded(this.postList);
}

class PostAdded extends ApiState {
  final String message;
  PostAdded(this.message);
}

class PostError extends ApiState {
  final String error;

  PostError(this.error);
}

class CommonSucees extends ApiState {
  final String message;
  CommonSucees(this.message);
}

class CommonError extends ApiState {
  final String error;

  CommonError(this.error);
}

class CommonLoading extends ApiState {}
