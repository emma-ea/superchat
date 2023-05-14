import 'package:equatable/equatable.dart';

class Chat extends Equatable {

  final DateTime sentTime;
  final String message;
  final String? userId;
  final bool sent;

  const Chat({required this.message, required this.sentTime, this.userId, this.sent = false});
  
  @override
  List<Object?> get props => [ message, sentTime ];

}

List<Chat> dummy = [
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '1111541', sent: false),
  Chat(message: 'Location', sentTime: DateTime.now(), userId: '1214151'),
  Chat(message: 'Student?', sentTime: DateTime.now(), userId: '5516651'),
  Chat(message: 'Where are you from', sentTime: DateTime.now(), userId: '762111'),
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '9886321', sent: false),
  Chat(message: 'Location', sentTime: DateTime.now(), userId: '1214151'),
  Chat(message: 'Student?', sentTime: DateTime.now(), userId: '5516651'),
  Chat(message: 'Where are you from', sentTime: DateTime.now(), userId: '762111'),
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '9886321', sent: false),
  Chat(message: 'Student?', sentTime: DateTime.now(), userId: '5516651'),
  Chat(message: 'Where are you from', sentTime: DateTime.now(), userId: '762111'),
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '9886321', sent: false),
  Chat(message: 'Location', sentTime: DateTime.now(), userId: '1214151'),
  Chat(message: 'Student?', sentTime: DateTime.now(), userId: '5516651'),
  Chat(message: 'Where are you from', sentTime: DateTime.now(), userId: '762111'),
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '9886321', sent: false),
  Chat(message: 'Location', sentTime: DateTime.now(), userId: '1214151'),
  Chat(message: 'Student?', sentTime: DateTime.now(), userId: '5516651', sent: false),
  Chat(message: 'Where are you from', sentTime: DateTime.now(), userId: '762111'),
  Chat(message: 'Hello', sentTime: DateTime.now(), userId: '9886321'),
];