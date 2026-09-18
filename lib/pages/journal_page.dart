import 'package:flutter/material.dart';

class JournalEntry {
  JournalEntry({
    required this.name,
    required this.location,
    required this.category,
    required this.note,
  });

  String name;
  String location;
  String category;
  String note;
}

class JournalPage extends StatefulWidget {
  const JournalPage({this.embedded = false, super.key});

  final bool embedded;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final List<JournalEntry> _entries = [
    JournalEntry(
      name: 'Sari Wulandari',
      location: 'Bantul, DIY',
      category: 'Wawancara',
      note: 'Perubahan pola kerja setelah musim panen.',
    ),
    JournalEntry(
      name: 'Made Suarta',
      location: 'Gianyar, Bali',
      category: 'Observasi',
      note: 'Persiapan upacara dimulai sejak pagi.',
    ),
  ];

  Future<void> _showEntryForm({JournalEntry? entry}) async {
    final nameController = TextEditingController(text: entry?.name);
    final locationController = TextEditingController(text: entry?.location);
    final noteController = TextEditingController(text: entry?.note);
    var category = entry?.category ?? 'Wawancara';

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(entry == null ? 'Tambah catatan' : 'Ubah catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama/kode narasumber',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Jenis catatan'),
                  items: const ['Wawancara', 'Observasi', 'Dokumen']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(() => category = value!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Ringkasan'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    noteController.text.trim().isEmpty) {
                  return;
                }
                if (entry == null) {
                  _entries.add(
                    JournalEntry(
                      name: nameController.text.trim(),
                      location: locationController.text.trim(),
                      category: category,
                      note: noteController.text.trim(),
                    ),
                  );
                } else {
                  entry
                    ..name = nameController.text.trim()
                    ..location = locationController.text.trim()
                    ..category = category
                    ..note = noteController.text.trim();
                }
                Navigator.pop(context, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    locationController.dispose();
    noteController.dispose();
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan ${entry.name} akan dihapus dari jurnal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) setState(() => _entries.remove(entry));
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: EdgeInsets.fromLTRB(20, widget.embedded ? 20 : 0, 20, 24),
      children: [
        Text(
          'Buku jurnal digital',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D241B),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${_entries.length} catatan tersimpan untuk sesi riset ini.',
          style: const TextStyle(color: Color(0xFF71675C)),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () => _showEntryForm(),
          icon: const Icon(Icons.add),
          label: const Text('Tambah catatan'),
        ),
        const SizedBox(height: 20),
        if (_entries.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Belum ada catatan dalam jurnal.'),
            ),
          )
        else
          ..._entries.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2D241B),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (action) {
                            if (action == 'edit') _showEntryForm(entry: entry);
                            if (action == 'delete') _deleteEntry(entry);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Ubah')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${entry.category}  |  ${entry.location.isEmpty ? 'Lokasi belum diisi' : entry.location}',
                      style: const TextStyle(color: Color(0xFF9A6819)),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.note),
                  ],
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.embedded) return content;
    return Scaffold(
      appBar: AppBar(title: const Text('Jurnal Riset')),
      body: content,
    );
  }
}
