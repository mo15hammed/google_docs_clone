import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/utils/snackbar_manager.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/document_repository.dart';
import '../theme/app_theme.dart';
import '../repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> signOut(WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  Future<void> createDocument(BuildContext context, WidgetRef ref) async {
    final token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    ref
        .read(documentRepositoryProvider)
        .createDocument(token)
        .then((errorModel) {
      if (errorModel.data != null) {
        navigator.push('/document/${errorModel.data.id}');
      } else {
        SnackBarManager.showSuccessSnackBar(context, errorModel.error!);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => createDocument(context, ref),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
            color: AppTheme.red,
          ),
        ],
      ),
      body: Center(
        child: Text(ref.watch(userProvider)!.uid),
      ),
    );
  }
}
