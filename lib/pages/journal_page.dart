import 'package:flutter/material.dart';
import '../data/journal_database.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class JournalEntry {
  JournalEntry({
    required this.id,
    required this.name,
    required this.location,
    this.note = '',
  });

  int id;
  String name;
  String location;
  String note;
}

class JournalPage extends StatefulWidget {
  const JournalPage({this.embedded = false, super.key});

  final bool embedded;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalDatabase _journalDatabase = JournalDatabase.instance;
  bool _hasLocalChanges = false;

  final List<JournalEntry> _entries = [];

  // Inline Form State
  bool _isFormOpen = false;
  JournalEntry? _editingEntry;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final records = await _journalDatabase.getEntries();
    if (!mounted || _hasLocalChanges) return;
    setState(() {
      _entries
        ..clear()
        ..addAll(
          records.map(
            (record) => JournalEntry(
              id: record.id,
              name: record.name,
              location: record.location,
              note: record.note,
            ),
          ),
        );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _openAddForm() {
    setState(() {
      _editingEntry = null;
      _nameController.clear();
      _locationController.clear();
      _noteController.clear();
      _isFormOpen = true;
    });
  }

  void _openEditForm(JournalEntry entry) {
    setState(() {
      _editingEntry = entry;
      _nameController.text = entry.name;
      _locationController.text = entry.location;
      _noteController.text = entry.note;
      _isFormOpen = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isFormOpen = false;
      _editingEntry = null;
      _nameController.clear();
      _locationController.clear();
      _noteController.clear();
    });
  }

  Future<void> _saveForm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final location = _locationController.text.trim().isEmpty
        ? '-'
        : _locationController.text.trim();
    final note = _noteController.text.trim();

    final editingEntry = _editingEntry;
    _hasLocalChanges = true;
    if (editingEntry == null) {
      final temporaryId = -DateTime.now().microsecondsSinceEpoch;
      setState(() {
        _entries.add(
          JournalEntry(
            id: temporaryId,
            name: name,
            location: location,
            note: note,
          ),
        );
        _isFormOpen = false;
        _editingEntry = null;
        _nameController.clear();
        _locationController.clear();
        _noteController.clear();
      });
      final id = await _journalDatabase.insertEntry(
        name: name,
        location: location,
        note: note,
      );
      if (!mounted) return;
      setState(() {
        final index = _entries.indexWhere((entry) => entry.id == temporaryId);
        if (index != -1) _entries[index].id = id;
      });
    } else {
      setState(() {
        editingEntry
          ..name = name
          ..location = location
          ..note = note;
        _isFormOpen = false;
        _editingEntry = null;
        _nameController.clear();
        _locationController.clear();
        _noteController.clear();
      });
      await _journalDatabase.updateEntry(
        id: editingEntry.id,
        name: name,
        location: location,
        note: note,
      );
    }
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data Responden?'),
        content: Text(
          'Data "${entry.name}" (ID: ${entry.id}) akan dihapus secara permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDB5A5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _hasLocalChanges = true;
      setState(() {
        _entries.remove(entry);
        if (_editingEntry == entry) {
          _closeForm();
        }
      });
      await _journalDatabase.deleteEntry(entry.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildMainContent();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image Asset matching 100% exact style
          Positioned.fill(
            child: Image.asset(
              'assets/images/calendar_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Scrollable Area
          SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Buku Jurnal Digital',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),

                // Content List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                    children: [
                      // Top Action Button: "Tambah Responden Baru"
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _openAddForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDB5A5A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Tambah Responden Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Form Input Card (Displayed when adding or editing)
                      if (_isFormOpen) ...[
                        _buildFormCard(),
                        const SizedBox(height: 14),
                      ],

                      // Summary Bar: Log Wawancara Terbaru (X Data)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Log Wawancara Terbaru',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            Text(
                              '${_entries.length} Data',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Respondent Items List
                      if (_entries.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Belum ada data responden.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF71675C),
                              ),
                            ),
                          ),
                        )
                      else
                        ..._entries.map((entry) => _buildEntryCard(entry)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Full-width Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 68,
              decoration: const BoxDecoration(color: Color(0xFFE29F2B)),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const MainMenuPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.access_time_rounded,
                      label: 'Stopwatch',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StopwatchPage(),
                          ),
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.info_outline_rounded,
                      label: 'Help',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ManualPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Form Card matching app UI theme
  Widget _buildFormCard() {
    final titleText = _editingEntry == null
        ? 'Tambah Responden Baru'
        : 'Edit Data Responden';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5A638), width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Inner Golden Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEB75B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Title
                  Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Label: Nama Responden
                  const Text(
                    'Nama Responden',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      key: const Key('nameField'),
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Masukkan nama responden',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Label: Lokasi Wawancara
                  const Text(
                    'Lokasi Wawancara',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _locationController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Masukkan lokasi wawancara',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Label: Catatan Wawancara
                  const Text(
                    'Catatan Wawancara',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Tulis ringkasan catatan wawancara...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons Row (Batal & Simpan)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: _closeForm,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5A638)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8E5D13),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB5A5A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Respondent Card Item (with Edit Pencil Icon & Delete Trash Icon)
  Widget _buildEntryCard(JournalEntry entry) {
    return Container(
      key: ValueKey('entry_${entry.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5A638), width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Left Info Column (ID, Nama, Lokasi, Catatan)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${entry.id}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF555555),
                    ),
                  ),
                  if (entry.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Catatan: ${entry.note}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E5D13),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right Action Pair (Box 1: Pensil / Edit, Box 2: Tong Sampah / Delete)
            Row(
              children: [
                // Box 1: Edit Pencil Icon (Kotak pertama dari kiri)
                InkWell(
                  onTap: () => _openEditForm(entry),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7D5B1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF8E5D13),
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Box 2: Delete Trash Icon (Kotak kedua)
                InkWell(
                  onTap: () => _deleteEntry(entry),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9B8B8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFB84A41),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Embedded view fallback
  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ElevatedButton(
          onPressed: _openAddForm,
          child: const Text('Tambah Responden Baru'),
        ),
        if (_isFormOpen) _buildFormCard(),
        ..._entries.map(
          (e) => ListTile(
            title: Text(e.name),
            subtitle: Text('${e.location} - ${e.note}'),
          ),
        ),
      ],
    );
  }

  // Bottom Nav Bar helper
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3E2712), size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3E2712),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
