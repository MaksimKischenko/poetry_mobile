
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';

abstract interface class Failure  {
  final String message;
  const Failure(this.message);
}



class SimpleFailure implements Failure {
  final Exception error;

  SimpleFailure({
    required this.error,
  });
  
  @override
  String get message => error.toString();
}

class FireBaseAuthFailure implements Failure {
  final FirebaseAuthException error;

  FireBaseAuthFailure({
    required this.error,
  });
  
  @override
  String get message {
    if(error.code == FireBaseAuthErroCode.userNotFound.fireBasemessage) {
      return FireBaseAuthErroCode.userNotFound.uiMessage;
    } else if (error.code == FireBaseAuthErroCode.existsEmail.fireBasemessage) {
      return FireBaseAuthErroCode.existsEmail.uiMessage;
    } else if (error.code == FireBaseAuthErroCode.userNotExists.fireBasemessage) {
      return FireBaseAuthErroCode.userNotExists.uiMessage;
    } else if (error.code == FireBaseAuthErroCode.wrongPassword.fireBasemessage) {
      return FireBaseAuthErroCode.wrongPassword.uiMessage;
    }
    else {
      return FireBaseAuthErroCode.unknown.uiMessage;
    }
  }
}

class FireBaseFailure implements Failure {
  final FirebaseException error;

  FireBaseFailure({
    required this.error,
  });
  
  @override
  String get message => error.code;
}


class NetworkSocketFailure implements Failure {
  final SocketException error;

  NetworkSocketFailure({
    required this.error,
  });
  
  @override
  String get message => error.message;
}



