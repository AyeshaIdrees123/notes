import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notes/bloc/bloc/block_bloc.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/log_in_screen.dart';
import 'package:notes/screens/note_detail_screen.dart';
import 'package:notes/screens/search_notes_screen.dart';
import 'package:notes/widgets/icon_container.dart';
import 'package:notes/widgets/notes_list_view.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  final _notesRef = _firestore.collection('notes').withConverter<Note>(
        fromFirestore: (snapshots, _) => Note.fromJson(snapshots.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  bool _isLoading = false;
  bool _isThemeDark = true;

  @override
  void initState() {
    super.initState();
    _loadSavedNotes();
  }

  Future<void> _loadSavedNotes() async {
    _notes.clear();
    _isLoading = true;
    final userID = _auth.currentUser?.uid;

    final notesSnapshot =
        await _notesRef.where('userId', isEqualTo: userID).get();

    for (var noteData in notesSnapshot.docs) {
      final note = noteData.data();
      _notes.add(note);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _deleteNote(Note note) async {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());

    final id = note.id;
    final noteDoc = _notesRef.doc(id);
    await noteDoc.delete();
    _notes.remove(note);
    Loader.hide();
    setState(() {});
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (x) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            logOut();
          },
          child: const Icon(Icons.login_outlined),
        ),
        titleSpacing: 0.9,
        title: const Text("Notes"),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              context.read<ThemeBloc>().add(ToggelEvent());
              setState(() {
                _isThemeDark = !_isThemeDark;
              });
            },
            child: BlocBuilder<ThemeBloc, ThemeMode>(
              builder: (context, state) {
                return IconContainer(
                    icon: state == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.dark_mode_outlined);
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchNotesScreen()));
              },
              child: const IconContainer(icon: Icons.search)),
          const SizedBox(width: 20),
          const IconContainer(icon: Icons.info_outline),
          const SizedBox(width: 20)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notes.isNotEmpty
                ? NotesListView(
                    notes: _notes,
                    onNotePressed: (note) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailsScreen(
                            note: note,
                            onNoteSaved: (_) async {
                              Loader.show(context,
                                  progressIndicator:
                                      const CircularProgressIndicator());
                              await _loadSavedNotes();
                              Loader.hide();
                            },
                          ),
                        ),
                      );
                    },
                    onDeletePressed: (note) {
                      _deleteNote(note);
                    },
                  )
                : Column(
                    children: [
                      Image.asset("assetes/images/notes.png"),
                      const Text(
                        "Create your first note !",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(-5, 0), blurRadius: 10)
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteDetailsScreen(
                          onNoteSaved: (_) {
                            _loadSavedNotes();
                          },
                        )));
          },
          shape: const CircleBorder(),
          backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
          elevation: 2,
          child: const Icon(
            Icons.add,
            size: 48,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.white,
                offset: Offset(0.2, 0.5),
                blurRadius: 5.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
