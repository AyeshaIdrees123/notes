import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/models/note.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({
    super.key,
    required this.notes,
    this.onNotePressed,
    this.onDeletePressed,
  });
  final List<Note> notes;
  final void Function(Note)? onNotePressed;
  final void Function(Note)? onDeletePressed;
  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.notes.length,
        itemBuilder: (context, index) {
          final note = widget.notes[index];
          return Slidable(
            startActionPane: ActionPane(
                extentRatio: 1,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      widget.onDeletePressed?.call(note);
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 46.0, vertical: 24),
                    backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(10),
                    label: 'Delete',
                  ),
                ]),
            child: InkWell(
              onTap: () {
                widget.onNotePressed?.call(note);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 46.0, vertical: 24),
                margin:
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 22),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(note.title,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            ),
          );
        });
  }
}
