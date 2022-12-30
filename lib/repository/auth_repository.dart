import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/api_constants.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/models/user_model.dart';
import 'package:google_docs_clone/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../constants/strings.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository()),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    var error = ErrorModel<void>(
      error: Strings.unexpectedError,
      data: null,
    );

    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        final userAccount = UserModel(
          name: user.displayName ?? '',
          email: user.email,
          profilePic: user.photoUrl ?? '',
        );
        final res = await _client.post(
          Uri.parse(ApiConstants.signUp),
          body: userAccount.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (res.statusCode == 200) {
          final newUser = userAccount.copyWith(
            token: jsonDecode(res.body)['token'],
            uid: jsonDecode(res.body)['user']['_id'],
          );
          error = ErrorModel<UserModel>(error: null, data: newUser);

          _localStorageRepository.setToken(newUser.token);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    var error = ErrorModel<void>(
      error: Strings.unexpectedError,
      data: null,
    );

    try {
      final token = await _localStorageRepository.getToken();

      if (token != null) {
        final res = await _client.get(
          Uri.parse(ApiConstants.getUserData),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        if (res.statusCode == 200) {
          final newUser = UserModel.fromJson(
            jsonEncode(jsonDecode(res.body)['user']),
          ).copyWith(token: token);

          error = ErrorModel<UserModel>(error: null, data: newUser);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _localStorageRepository.removeToken();
  }
}
