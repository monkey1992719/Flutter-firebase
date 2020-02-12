import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/auth/auth.dart';

class AppState {

  // Address to photograph.
  final String address;

  // Authentication class.
  final BaseAuth auth;

  // First name of user.
  final String firstName;

  // Instructions to photographer.
  final String instructions;

  // Last name of user.
  final String lastName;

  // Location to photograph.
  final LatLng location;

  // Message to display to user.
  final String message;

  // Authenticated user.
  final FirebaseUser user;

  AppState({
    this.address,
    this.auth,
    this.firstName,
    this.instructions,
    this.lastName,
    this.location,
    this.message,
    this.user,
  });

  AppState copy(
      {
        String address,
        BaseAuth auth,
        String firstName,
        String instructions,
        String lastName,
        LatLng location,
        String message,
        FirebaseUser user,
      }) {
    return new AppState(
      address: address ?? this.address,
      auth: auth ?? this.auth,
      firstName: firstName ?? this.firstName,
      instructions: instructions ?? this.instructions,
      lastName: lastName ?? this.lastName,
      location: location ?? this.location,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  static AppState initialState() => AppState(
    address: '',
    auth: null,
    firstName: '',
    instructions: '',
    lastName: '',
    location: LatLng(0, 0),
    message: '',
    user: null,
  );

  @override
  int get hashCode =>
    address.hashCode ^
    auth.hashCode ^
    firstName.hashCode ^
    instructions.hashCode ^
    lastName.hashCode ^
    location.hashCode ^
    message.hashCode ^
    user.hashCode
  ;

  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              address == other.address &&
              auth == other.auth &&
              firstName == other.firstName &&
              instructions == other.instructions &&
              lastName == other.lastName &&
              location == other.location &&
              message == other.message &&
              user == other.user
  ;

  @override
  String toString() {
    return 'AppState{'
        'address: $address,'
        'auth: $auth,'
        'firstName: $firstName,'
        'instructions: $instructions,'
        'lastName: $lastName,'
        'location: $location,'
        'message: $message,'
        'user: $user}';
  }
}
