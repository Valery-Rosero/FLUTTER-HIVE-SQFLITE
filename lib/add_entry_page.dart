import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  String _selectedEmotion = "🙂";

  final List<String> emotions = ["😃", "😔", "😡", "😴", "🤩", "🙂"];

  void _saveEntry() async {
    if (_contentController.text.isEmpty) return;

    await dbHelper.insertEntry({
      "date": DateTime.now().toIso8601String(),
      "content": _contentController.text,
      "emotion": _selectedEmotion,
      "tags": _tagsController.text,
    });

    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Entrada")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("¿Cómo te sientes hoy?", style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 10,
              children: emotions.map((e) {
                return ChoiceChip(
                  label: Text(e, style: const TextStyle(fontSize: 20)),
                  selected: _selectedEmotion == e,
                  onSelected: (_) {
                    setState(() {
                      _selectedEmotion = e;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Escribe tu día...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: "Etiquetas (separadas por coma)",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _saveEntry,
              icon: const Icon(Icons.save),
              label: const Text("Guardar Entrada"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
