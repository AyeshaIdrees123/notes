import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/icon_container.dart';
import 'package:notes/widgets/notes_list_view.dart';

class SearchNotesScreen extends StatefulWidget {
  const SearchNotesScreen({super.key});

  @override
  State<SearchNotesScreen> createState() => _SearchNotesScreenState();
}

class _SearchNotesScreenState extends State<SearchNotesScreen> {
  final TextEditingController searchColntroller = TextEditingController();
  List<Note> notes = [];
  List<Note> notesCopyList = [];
  bool variabl = true;

  static final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _notesRef = _firestore.collection("notes").withConverter<Note>(
        fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  @override
  void initState() {
    super.initState();
    _fetchNotes(); // Fetch notes
    _showLoadingIndicator(); // Show a loading indicator
    print("UI enhancements for notes fetching in ui-fix branch");
  }

  void _fetchNotes() async {
    final userID = _auth.currentUser?.uid;

    final noteSnapShote =
        await _notesRef.where('userId', isEqualTo: userID).get();
    for (var noteData in noteSnapShote.docs) {
      final note = noteData.data();
      notes.add(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 88),
            Row(
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const IconContainer(icon: Icons.arrow_back_ios)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      onChanged: (value) {
                        notesCopyList.addAll(notes);
                        if (value.isEmpty) {
                          notesCopyList.clear();
                        } else {
                          notesCopyList = notes.where((note) {
                            return note.title
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        }

                        setState(() {});
                      },
                      controller: searchColntroller,
                      autofocus: true,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: InkWell(
                              onTap: () {
                                searchColntroller.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close)),
                        ),
                        suffixIconColor: Colors.white,
                        hintText: "Search by the keyword...",
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(204, 204, 204, 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            notesCopyList.isNotEmpty
                ? Expanded(
                    child: NotesListView(
                    notes: notesCopyList,
                  ))
                : Image.asset("assetes/images/searchpage.png"),
            const Text(
              "File not found. Try searching again.",
              style: TextStyle(color: Color.fromRGBO(225, 225, 225, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
