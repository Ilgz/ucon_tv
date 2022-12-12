part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}
class LoginUser extends RegisterEvent {
  String phoneNumber;
  int server;
  LoginUser(this.phoneNumber,this.server);
}