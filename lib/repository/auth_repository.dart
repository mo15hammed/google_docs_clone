import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/api_constants.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../constants/strings.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
  })  : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    var error = ErrorModel<void>(
      error: Strings.unexpectedError,
      data: null,
    );

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
          name: user.displayName!,
          email: user.email,
          profilePic: user.photoUrl!,
        );

        final res = await _client.post(
          Uri.parse(ApiConstants.signUp),
          body: userAccount.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        switch (res.statusCode) {
          case 200:
            final newUser = userAccount.copyWith(
              token: '',
              uid: jsonDecode(res.body)['user']['_id'],
            );

            error = ErrorModel<UserModel>(error: null, data: newUser);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }
}
