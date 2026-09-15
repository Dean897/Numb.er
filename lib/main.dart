import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _maxCalculatorDigits = 15;
const _maxOddEvenDigits = 18;

class _CalculatorDigitLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitCount = newValue.text.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digitCount <= _maxCalculatorDigits ? newValue : oldValue;
  }
}

class _OddEvenDigitLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitCount = newValue.text.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digitCount <= _maxOddEvenDigits ? newValue : oldValue;
  }
}

void main() {
  runApp(const TerminalMathApp());
}

AppBar buildCharcoalAppBar(
  BuildContext context, {
  required String title,
  bool showBackButton = true,
}) {
  return AppBar(
    backgroundColor: const Color(0xFF2D3142),
    foregroundColor: Colors.white,
    elevation: 2,
    automaticallyImplyLeading: false,
    leading: showBackButton
        ? IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        tooltip: 'Keluar aplikasi',
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        ),
      ),
    ],
  );
}

class TerminalMathApp extends StatelessWidget {
  const TerminalMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryDarkGray = Color(0xFF2D3142);
    const bgLightGray = Color(0xFFF4F4F6);
    const borderGray = Color(0xFFE0E0E4);

    return MaterialApp(
      title: 'Terminal Math & Team Utility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryDarkGray,
          brightness: Brightness.light,
          surface: bgLightGray,
        ),
        scaffoldBackgroundColor: bgLightGray,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDarkGray,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: borderGray, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryDarkGray, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryDarkGray,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    if (_usernameController.text.trim() == 'admin' &&
        _passwordController.text == '12345') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainMenuPage()),
      );
      return;
    }

    setState(() => _errorMessage = 'Username atau password salah.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hiasan setengah bulat pada bagian atas background
          Positioned(
            top: 0,
            left: -40,
            right: -40,
            height: 250,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD8D8E0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(260, 140),
                  bottomRight: Radius.elliptical(260, 140),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0xFF2D3142),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.calculate_outlined,
                              size: 64,
                              color: Color(0xFF2D3142),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Numb.er',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3142),
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SELAMAT DATANG',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF666666),
                                    letterSpacing: 1.0,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Username wajib diisi'
                                  : null,
                              onFieldSubmitted: (_) => _login(),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Password wajib diisi'
                                  : null,
                              onFieldSubmitted: (_) => _login(),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: _login,
                              icon: const Icon(Icons.login),
                              label: const Text('Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static const members = [
    ('Deandra', '124240144', 'Programmer'),
    ('Habrian', '124240126', 'Tester, UI/UX'),
    ('Titan', '124240152', 'UI/UX'),
  ];

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      (
        'Data Kelompok',
        'Lihat anggota dan pembagian tugas',
        Icons.groups_outlined,
        () => _openPage(context, const GroupDataPage(members: members)),
      ),
      (
        'Kalkulator',
        'Tambah, kurang, kali, dan bagi',
        Icons.calculate_outlined,
        () => _openPage(context, const CalculatorPage()),
      ),
      (
        'Ganjil / Genap',
        'Periksa jenis sebuah bilangan',
        Icons.numbers_outlined,
        () => _openPage(context, const OddEvenPage()),
      ),
      (
        'Total Angka',
        'Jumlahkan setiap digit angka',
        Icons.functions,
        () => _openPage(context, const DigitSumPage()),
      ),
    ];

    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Menu Utama',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Numb.er',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pilih aktivitas yang ingin dijalankan.',
            style: TextStyle(color: Color(0xFF666666)),
          ),
          const SizedBox(height: 20),
          ...menuItems.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.$3, color: const Color(0xFF2D3142)),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                subtitle: Text(
                  item.$2,
                  style: const TextStyle(color: Color(0xFF666666)),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF888888),
                ),
                onTap: item.$4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupDataPage extends StatelessWidget {
  const GroupDataPage({required this.members, super.key});

  final List<(String, String, String)> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Data Kelompok 4',
        showBackButton: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
              title: Text(
                member.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              subtitle: Text(
                'NIM: ${member.$2}\nTugas: ${member.$3}',
                style: const TextStyle(color: Color(0xFF555555), height: 1.4),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();
  String _operator = '+';
  String? _result;
  String? _error;

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _calculate() {
    final firstText = _firstController.text.trim();
    final secondText = _secondController.text.trim();
    final first = double.tryParse(firstText);
    final second = double.tryParse(secondText);
    final hasTooManyDigits = [firstText, secondText].any(
      (value) =>
          RegExp(r'[0-9]').allMatches(value).length > _maxCalculatorDigits,
    );
    if (first == null || second == null || hasTooManyDigits) {
      setState(() {
        _error =
            'Masukkan angka yang valid dengan maksimal $_maxCalculatorDigits digit per input.';
        _result = null;
      });
      return;
    }
    if (_operator == '/' && second == 0) {
      setState(() {
        _error = 'Pembagian dengan nol tidak diperbolehkan.';
        _result = null;
      });
      return;
    }

    final result = switch (_operator) {
      '+' => first + second,
      '-' => first - second,
      '*' => first * second,
      _ => first / second,
    };
    if (!result.isFinite) {
      setState(() {
        _error = 'Hasil terlalu besar untuk dihitung.';
        _result = null;
      });
      return;
    }
    setState(() {
      _error = null;
      _result =
          '${formatNumber(first)} $_operator ${formatNumber(second)} = '
          '${formatNumber(result)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Kalkulator',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _firstController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [_CalculatorDigitLimitFormatter()],
            maxLength: 17,
            decoration: const InputDecoration(labelText: 'Angka pertama'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _secondController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [_CalculatorDigitLimitFormatter()],
            maxLength: 17,
            decoration: const InputDecoration(labelText: 'Angka kedua'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _operator,
            decoration: const InputDecoration(labelText: 'Operator'),
            items: ['+', '-', '*', '/']
                .map(
                  (operator) =>
                      DropdownMenuItem(value: operator, child: Text(operator)),
                )
                .toList(),
            onChanged: (value) => setState(() => _operator = value!),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate),
            label: const Text('Hitung'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 20),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            ResultCard(label: 'Hasil', value: _result!),
          ],
        ],
      ),
    );
  }
}

class OddEvenPage extends StatefulWidget {
  const OddEvenPage({super.key});

  @override
  State<OddEvenPage> createState() => _OddEvenPageState();
}

class _OddEvenPageState extends State<OddEvenPage> {
  final _controller = TextEditingController();
  String? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final input = _controller.text.trim();
    final digitCount = RegExp(r'[0-9]').allMatches(input).length;
    final isTooLong = digitCount > _maxOddEvenDigits;
    final isValidInteger = RegExp(r'^-?[0-9]+$').hasMatch(input);
    final lastDigit = isValidInteger
        ? int.parse(input.substring(input.length - 1))
        : null;
    setState(() {
      _result = isTooLong
          ? 'Bilangan maksimal $_maxOddEvenDigits digit.'
          : !isValidInteger
          ? 'Masukkan bilangan bulat yang valid.'
          : '$input adalah bilangan ${lastDigit!.isEven ? 'GENAP' : 'GANJIL'}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Cek Ganjil / Genap',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [_OddEvenDigitLimitFormatter()],
              maxLength: 19,
              decoration: const InputDecoration(
                labelText: 'Masukkan bilangan (maks. 18 digit)',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Periksa'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              ResultCard(label: 'Hasil', value: _result!),
            ],
          ],
        ),
      ),
    );
  }
}

class DigitSumPage extends StatefulWidget {
  const DigitSumPage({super.key});

  @override
  State<DigitSumPage> createState() => _DigitSumPageState();
}

class _DigitSumPageState extends State<DigitSumPage> {
  final _controller = TextEditingController();
  String? _error;
  String? _process;
  int? _total;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sum() {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        _error = 'Masukkan angka atau kalimat yang berisi angka.';
        _process = null;
        _total = null;
      });
      return;
    }

    final isDigitSequence = RegExp(r'^\d+$').hasMatch(input);
    final numbers = isDigitSequence
        ? input.split('').map(int.parse).toList()
        : RegExp(r'\d+').allMatches(input).expand((match) {
            final value = match.group(0)!;
            final startsWithLetter =
                match.start > 0 &&
                RegExp(r'[A-Za-z]').hasMatch(input[match.start - 1]);
            final endsWithLetter =
                match.end < input.length &&
                RegExp(r'[A-Za-z]').hasMatch(input[match.end]);

            return startsWithLetter || endsWithLetter
                ? value.split('').map(int.parse)
                : [int.parse(value)];
          }).toList();

    if (numbers.isEmpty) {
      setState(() {
        _error = 'Tidak ditemukan angka pada input.';
        _process = null;
        _total = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _process = numbers.join(' + ');
      _total = numbers.reduce((sum, number) => sum + number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Total Jumlah Angka',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Angka atau kalimat berisi angka',
                hintText: 'Contoh: 852 atau Saya punya 12 dan 3',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _sum,
              icon: const Icon(Icons.functions),
              label: const Text('Jumlahkan'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_total != null) ...[
              const SizedBox(height: 24),
              ResultCard(label: 'Proses', value: _process!),
              const SizedBox(height: 12),
              ResultCard(label: 'Total', value: '$_total'),
            ],
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEAEAEE),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD0D0D8), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF555555),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF1F2128),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(double value) {
  return value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}
