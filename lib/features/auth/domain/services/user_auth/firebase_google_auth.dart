// ignore_for_file: unused_field
import 'package:googleapis/drive/v3.dart' as drive;
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/features/auth/data/firebase_auth_data.dart';
import 'package:slides_sync/features/auth/domain/models/user_credential_model.dart';
import 'package:slides_sync/features/auth/domain/usecases/auth_uc/user_data_functions.dart';

class FirebaseGoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  final GoogleSignIn _googleAuth = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );
  final FirebaseAuthData _firebaseData = FirebaseAuthData();
  UserCredential? _userCredential;
  final UserDataFunctions userData = UserDataFunctions();

  Future<Result<UserCredentialModel>> signInWithGoogle({String? phoneNumber}) async {
    
    try {
      // Triggering the authentication flow
      final GoogleSignInAccount? googleUser = await _googleAuth.signIn();
      if (googleUser == null) {
        return Result.error("Google Sign-In was canceled by the user.");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return Result.error("Unknown user!");

      final Result outcomeCreateUser = await _firebaseData.createUserData(
        UserCredentialModel(
          userID: user.uid,
          displayName: user.displayName ?? "Anonymous",
          email: user.email ?? "anonymous@gmail.com",
          phoneNumber: phoneNumber,
          photoURL: user.photoURL,
          creationTime: DateTime.now(),
        ),
      );

      if (outcomeCreateUser.isSuccess) {
        await userData.saveUserDetails(
          googleAccessToken: googleAuth.accessToken,
          googleIDToken: googleAuth.idToken,
          userCredentialModel: outcomeCreateUser.data,
        );
        return Result.success(outcomeCreateUser.data);
      } else {
        return Result.error("Unable to create User Data");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return Result.error("Account already exists with a different credential!");
      } else if (e.code == 'invalid-credential') {
        return Result.error("Invalid credentials!");
      } else if (e.code == "wrong-password") {
        return Result.error("Incorrect password was entered!");
      } else {
        return Result.error("An unknown error occurred!");
      }
    } catch (e) {
      log(e.toString());
      return Result.error("An error occurred during Google Sign-In");
    }
  }

  Future<Result<bool>> googleSignOut([void Function()? beforeSignOut]) async {
    try {
      final Result<UserCredentialModel?> getUserDetails = await userData.getUserDetails();
      if (getUserDetails.data == null || getUserDetails.isSuccess == false) {
        return Result.error("Error getting details from storage. Try clearing cache");
      }

      await userData.clearUserDetails();
      if (beforeSignOut != null) beforeSignOut();
      await _googleAuth.signOut();
      await _firebaseAuth.signOut();

      return Result.success(true);
    } catch (e) {
      return Result.error("Error: $e");
    }
  }
}
