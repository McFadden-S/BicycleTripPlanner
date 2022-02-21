import 'package:bicycle_trip_planner/constants.dart';
import 'package:flutter/material.dart';

//Custom class in project directory
class ErrorSnackBar {
  ErrorSnackBar._();

  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage(message)),
        duration: const Duration(seconds: 3),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  // Checks error message from firebase to display user friendly one
  static String errorMessage(String error) {
    if (error.contains("wrong-password")) {
      error = "Incorrect password. Please try again";
    } else if (error.contains("unknown")) {
      error = "One of the fields is empty. Please try again";
    } else if (error.contains("email-already-in-use")) {
      error = "Email address was already used by another account";
    } else if (error.contains("invalid-email")) {
      error = "Email address entered is invalid";
    } else if (error.contains("weak-password")) {
      error = "Password must contain at least 6 characters";
    } else if (error.contains("passwords-do-not-match")) {
      error = "Passwords do not match";
    } else if (error.contains("user-not-found")) {
      error="User not found. Please try again";
    } else if (error.contains("password-reset-sent")) {
      error = "Email sent to reset password";
    } else {
      error = "Error. Please try again";
    }
    return error;
  }

}