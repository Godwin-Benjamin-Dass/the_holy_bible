import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/screens/notes_flow/note_editor_page.dart';
import 'package:holy_bible_tamil/service.dart/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  Map<String, List<Map<String, dynamic>>> groupedNotes = {};

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DBHelper.getNotes();
    groupedNotes.clear();
    for (var note in notes) {
      String date = note['date'];
      groupedNotes.putIfAbsent(date, () => []).add(note);
    }
    setState(() {});
  }

  void _openEditor({Map<String, dynamic>? note}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorPage(note: note),
      ),
    );
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    BackButton(),
                    Tooltip(
                        message:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .myNotes,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * .6,
                          child: AutoSizeText(
                            Provider.of<ThemeProvider>(context, listen: false)
                                .myNotes,
                            maxFontSize: 17,
                            minFontSize: 17,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
      body: groupedNotes.isEmpty
          ? Center(
              child: Text(Provider.of<ThemeProvider>(context, listen: false)
                  .noNotesyet))
          : ListView(
              children: groupedNotes.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.value[0]['title'].toString()),
                  children: entry.value.map((note) {
                    return ListTile(
                      title: Text(
                        note['content'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        note['date'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () async {
                              Share.share(
                                  '${note['title']}\n\n${note['content']}');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await DBHelper.deleteNote(note['id']);
                              _loadNotes();
                            },
                          ),
                        ],
                      ),
                      onTap: () => _openEditor(note: note),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
    );
  }
}
