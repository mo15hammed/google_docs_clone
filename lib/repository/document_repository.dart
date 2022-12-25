import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../constants/api_constants.dart';
import '../constants/strings.dart';
import '../models/document_model.dart';
import '../models/error_model.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    var error = ErrorModel<void>(
      error: Strings.unexpectedError,
      data: null,
    );

    try {
      final res = await _client.post(
        Uri.parse(ApiConstants.createDocument),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (res.statusCode == 200) {
        error = ErrorModel<DocumentModel>(
          error: null,
          data: DocumentModel.fromJson(res.body),
        );
      } else {
        error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }
}
