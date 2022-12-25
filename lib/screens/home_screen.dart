import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../constants/sizes.dart';
import '../models/error_model.dart';
import '../repository/document_repository.dart';
import '../theme/app_theme.dart';
import '../repository/auth_repository.dart';
import '../widgets/custom_loading_view.dart';
import '../models/document_model.dart';
import '../utils/snackbar_manager.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> signOut(WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  Future<void> createDocument(
    BuildContext context,
    WidgetRef ref,
    String token,
  ) async {
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

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(userProvider)!.token;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.green,
        actions: [
          IconButton(
            onPressed: () => createDocument(context, ref, token),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
            color: AppTheme.red,
          ),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref.watch(documentRepositoryProvider).getDocuments(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingView();
          }

          return Center(
            child: SizedBox(
              width: Sizes.s600,
              child: ListView.separated(
                padding: const EdgeInsets.all(Sizes.s20),
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.data[index] as DocumentModel;
                  return InkWell(
                    onTap: () => navigateToDocument(context, doc.id),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: Sizes.s12, horizontal: Sizes.s24),
                        child: Text(
                          doc.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: Sizes.s16),
              ),
            ),
          );
        },
      ),
    );
  }
}
