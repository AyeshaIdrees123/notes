import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notes/cards/confirmation_dialogue.dart';
import 'package:notes/models/note.dart';
// import 'package:notes/widgets/app_theme.dart';
import 'package:notes/widgets/icon_container.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({
    super.key,
    this.note,
    this.onNoteSaved,
    this.userID,
  });
  final String? userID;
  final Note? note;
  final void Function(Note)? onNoteSaved;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note == null) {
      _canEdit = true;
    }

    _titleController.text = widget.note?.title ?? '';
    _detailController.text = widget.note?.detail ?? '';
  }

  bool _canEdit = false;

  final decoration = InputDecoration(
    hintText: '',
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              const SizedBox(width: 23),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  if (_canEdit) {
                    if (_titleController.text.isNotEmpty ||
                        _detailController.text.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmationDialogue(
                              title: widget.note == null
                                  ? 'Are you sure you want \n discard your Note'
                                  : 'Are your sure you want \n discard your changes ?',
                              yesButtonTitle: 'Keep',
                              onPressed: (isYes) {
                                if (!isYes) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          });
                    } else {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const IconContainer(
                  icon: Icons.arrow_back_ios_new_outlined,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    // borderRadius: ,
                    onTap: () {
                      setState(() {
                        _canEdit = !_canEdit;
                      });
                    },
                    child: IconContainer(
                        icon: _canEdit ? Icons.visibility : Icons.edit),
                  ),
                  if (_canEdit) ...[
                    const SizedBox(width: 23),
                    InkWell(
                      // borderRadius: ,
                      onTap: () {
                        if (_titleController.text.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmationDialogue(
                                  title: widget.note == null
                                      ? 'Save your Note ?'
                                      : 'Save changes ?',
                                  onPressed: (isYes) {
                                    if (isYes) {
                                      _saveNote();
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              });
                        }
                      },
                      child: const IconContainer(icon: Icons.save),
                    ),
                  ]
                ],
              ),
              const SizedBox(width: 23),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _titleController,
            enabled: _canEdit,
            style: const TextStyle(fontSize: 48),
            autofocus: true,
            maxLines: null,
            decoration: decoration.copyWith(
                hintText: 'Title',
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                    fontSize: 48)),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: TextField(
                controller: _detailController,
                enabled: _canEdit,
                style: const TextStyle(fontSize: 23),
                autofocus: true,
                maxLines: null,
                decoration: decoration.copyWith(
                  hintText: _canEdit ? 'Type something' : "No details",
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                      fontSize: 23),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNote() async {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    final userId = auth.currentUser?.uid;

    if (userId != null) {
      final notesRef = firestore.collection('notes').withConverter<Note>(
            fromFirestore: (snapshots, _) => Note.fromJson(snapshots.data()!),
            toFirestore: (note, _) => note.toJson(),
          );

      var id = widget.note?.id;

      final noteDoc = notesRef.doc(id); //create new if null or else fetches old
      final note = Note(
        id: noteDoc.id,
        title: _titleController.text,
        detail: _detailController.text,
        userId: userId,
      );
      await noteDoc.set(note);
      widget.onNoteSaved?.call(note);
      Loader.hide();
    }
  }
}
