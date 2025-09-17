import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_entry_page.dart';

class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<EntryListPage> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    var data = await dbHelper.getEntries();
    setState(() {
      _entries = data;
    });
  }

  void _goToAddEntry() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEntryPage()),
    );

    if (result == true) {
      _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Diario 📝")),
      body: _entries.isEmpty
          ? const Center(child: Text("Aún no tienes entradas"))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                var entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(entry["content"]),
                    subtitle: Text(
                      "${entry["date"].toString().substring(0, 10)} - ${entry["tags"] ?? ""}",
                    ),
                    leading: Text(entry["emotion"], style: const TextStyle(fontSize: 24)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
