// ignore_for_file: unused_field

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/features/auth/data/firebase_auth_data.dart';
import 'package:slides_sync/features/auth/domain/models/user_credential_model.dart';
import 'package:slides_sync/features/auth/domain/usecases/auth_uc/user_data_functions.dart';

class FirebasePhoneAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  final FirebaseAuthData _firebaseData = FirebaseAuthData();
  final UserDataFunctions userData = UserDataFunctions();
  // This will temporarily store the verificationId returned from Firebase.
  String? _verificationId;

  /// Starts phone number authentication.
  ///
  /// This method sends a verification code (SMS) to the provided [phoneNumber]
  /// and sets up callbacks for auto-retrieval and manual code entry.
  ///
  /// - If auto-verification is successful, the user is immediately signed in.
  /// - Otherwise, once the SMS is sent, the method completes successfully and
  ///   you should prompt the user to enter the OTP, then call [verifyOTP].
  Future<Result<bool>> signInWithPhone(String phoneNumber) async {
    final Completer<Result<bool>> completer = Completer();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      // Called when the phone number is instantly verified or auto-retrieval
      // has completed. In this case, [credential] can be used to sign in.
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
          final User? user = userCredential.user;
          if (user == null) {
            if (!completer.isCompleted) {
              completer.complete(Result.error("Null user during auto-verification."));
            }
            return;
          }
          // Create user data in Firestore.
          final Result outcomeCreateUser = await _firebaseData.createUserData(
            UserCredentialModel(
              userID: user.uid,
              displayName: user.displayName ?? "",
              email: user.email ?? "",
              phoneNumber: user.phoneNumber,
            ),
          );
          if (outcomeCreateUser.isSuccess) {
            // Save the user details; you can also store the phone number here.
            await userData.saveUserDetails(userCredentialModel: outcomeCreateUser.data);
            if (!completer.isCompleted) {
              completer.complete(Result.success(true));
            }
          } else {
            if (!completer.isCompleted) {
              completer.complete(Result.error("Unable to create user data."));
            }
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.complete(Result.error("Auto-verification error: $e"));
          }
        }
      },
      // Called when verification fails.
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.complete(Result.error("Phone verification failed: ${e.message}"));
        }
      },
      // Called when the SMS code has been sent to the provided phone number.
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID for later use in [verifyOTP].
        _verificationId = verificationId;
        if (!completer.isCompleted) {
          completer.complete(Result.success(true));
        }
      },
      // Called when the auto-retrieval timeout occurs.
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        // No need to complete the completer here since either [codeSent] or
        // [verificationCompleted] should have already been called.
      },
    );

    return completer.future;
  }

  /// Verifies the OTP code entered by the user.
  ///
  /// This method creates a [PhoneAuthCredential] using the stored [_verificationId]
  /// and the provided [smsCode], then signs the user in.
  ///
  /// If the sign in is successful, it also creates the user data in Firestore
  /// and saves the user details.
  Future<Result<bool>> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      return Result.error("Verification ID is null. Please request a new code.");
    }
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return Result.error("Null user after OTP verification.");

      // Create user data in Firestore.
      final Result outcomeCreateUser = await _firebaseData.createUserData(
        UserCredentialModel(
          userID: user.uid,
          displayName: user.displayName ?? "",
          email: user.email ?? "",
          phoneNumber: user.phoneNumber,
        ),
      );
      if (outcomeCreateUser.isSuccess) {
        userData.saveUserDetails(userCredentialModel: outcomeCreateUser.data);
        return Result.success(true);
      } else {
        return Result.error("Unable to create user data.");
      }
    } catch (e) {
      return Result.error("Error verifying OTP: $e");
    }
  }

  /// Signs the user out of phone authentication.
  Future<Result<bool>> phoneSignOut() async {
    try {
      await _firebaseAuth.signOut();
      userData.clearUserDetails();
      return Result.success(true);
    } catch (e) {
      return Result.error("Error during phone sign-out: $e");
    }
  }
}
