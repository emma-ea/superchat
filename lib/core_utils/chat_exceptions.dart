import 'package:equatable/equatable.dart';

abstract class ChatExceptions extends Equatable implements Exception {
  final String error;
  const ChatExceptions(this.error);

  @override
  String toString() => '$runtimeType $error';

  @override
  List<Object?> get props => [error];

}

class CategoryCreationException extends ChatExceptions {
  const CategoryCreationException(super.error);
}

class CategoryFetchException extends ChatExceptions {
  const CategoryFetchException(super.error);
}

class UserCreationException extends ChatExceptions {
  const UserCreationException(super.error);
}

class UserInfoUpdateException extends ChatExceptions {
  const UserInfoUpdateException(super.error);
}

class ChatRoomCreationException extends ChatExceptions {
  const ChatRoomCreationException(super.error);
}

class DataConnectionTimeout extends ChatExceptions {
  const DataConnectionTimeout(super.error);
}