import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/repository/socket_repository.dart';
import 'package:google_docs_clone/utils/snackbar_manager.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';
import '../repository/document_repository.dart';
import '../theme/app_theme.dart';
import '../constants/strings.dart';
import '../constants/sizes.dart';
import '../constants/assets_constants.dart';
import '../models/document_model.dart';
import '../models/error_model.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController _titleCtrl =
      TextEditingController(text: Strings.untitledDocument);

  final QuillController _controller = QuillController.basic();

  ErrorModel? errorModel;

  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    getDocumentData();

    socketRepository.changeListener((data) {
      _controller.compose(
        Delta.fromJson(data['delta']),
        _controller.selection,
        ChangeSource.REMOTE,
      );
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave({
        'room': widget.id,
        'delta': _controller.document.toDelta(),
      });
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref) {
    final token = ref.read(userProvider)!.token;

    ref.read(documentRepositoryProvider).updateTitle(
          token: token,
          id: widget.id,
          title: _titleCtrl.text,
        );
  }

  void getDocumentData() async {
    final token = ref.read(userProvider)!.token;

    errorModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(token, widget.id);

    if (errorModel?.data != null) {
      final doc = errorModel!.data as DocumentModel;
      _titleCtrl.text = doc.title;

      _controller.document = doc.content.isEmpty
          ? Document()
          : Document.fromDelta(Delta.fromJson(doc.content));

      listenToDocumentChanges();
    }
  }

  void listenToDocumentChanges() {
    _controller.document.changes.listen(
      (event) {
        // 1 -> entire content
        // 2 -> new changes
        // 3 -> change source (local || remote)

        if (event.item3 == ChangeSource.LOCAL) {
          final data = {
            'delta': event.item2,
            'room': widget.id,
          };

          socketRepository.typing(data);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(Sizes.s10),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: 'http://localhost:3000/#/document/${widget.id}',
                ));
                SnackBarManager.showDefaultSnackBar(
                  context,
                  Strings.linkCopied,
                );
              },
              icon: const Icon(Icons.lock, size: Sizes.s16),
              label: const Text(Strings.share),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blue,
                foregroundColor: AppTheme.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.s6),
                ),
              ),
            ),
          )
        ],
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Routemaster.of(context).replace('/');
              },
              child: Image.asset(
                AssetsConstants.docsLogo,
                height: Sizes.s40,
              ),
            ),
            const SizedBox(width: Sizes.s12),
            Flexible(
              child: SizedBox(
                width: Sizes.s600,
                child: TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: Sizes.s10),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.blue),
                    ),
                  ),
                  onSubmitted: (value) => updateTitle(ref),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: Sizes.s10),
            QuillToolbar.basic(
              controller: _controller,
              showSmallButton: true,
              showAlignmentButtons: true,
              showDirection: true,
            ),
            const SizedBox(height: Sizes.s10),
            Expanded(
              child: SizedBox(
                width: Sizes.s800,
                child: Card(
                  color: AppTheme.white,
                  surfaceTintColor: Colors.white,
                  elevation: Sizes.s6,
                  shape: const BeveledRectangleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.s28),
                    child: QuillEditor.basic(
                      controller: _controller,
                      readOnly: false,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
