import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _controller = TextEditingController();
  Uint8List? picked;
  String? pickedName;
  bool saving = false;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(withData: true, allowMultiple: false);
    if (res != null && res.files.isNotEmpty) {
      picked = res.files.first.bytes;
      pickedName = res.files.first.name;
      setState(() {});
    }
  }

  Future<void> _save() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    setState(() => saving = true);
    final ok = await SupabaseService.createItem(title, imageBytes: picked, filename: pickedName);
    setState(() => saving = false);
    if (ok) Navigator.of(context).pop(true);
    if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _pick, icon: const Icon(Icons.image), label: const Text('Pick Image')),
            if (pickedName != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(pickedName!)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : _save,
                child: saving ? const CircularProgressIndicator() : const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
