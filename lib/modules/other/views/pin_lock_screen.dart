import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PinLockScreen extends StatefulWidget {
  final Function onAuthenticated;
  final bool isSetup;
  const PinLockScreen({Key? key, required this.onAuthenticated, this.isSetup = false}) : super(key: key);

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _pin = "";

  void _onKeyPress(String key) {
    setState(() {
      if (key == "⌫") {
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      } else if (_pin.length < 4) {
        _pin += key;
      }
    });

    if (_pin.length == 4) {
      // For now, let's say the pin is 1234 or we are in setup mode
      if (widget.isSetup || _pin == "1234") {
        widget.onAuthenticated(_pin);
      } else {
        // Wrong PIN effect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect PIN'), duration: Duration(seconds: 1)),
        );
        setState(() => _pin = "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: Color(0xFFE8E5A2), size: 64),
            const SizedBox(height: 24),
            Text(
              widget.isSetup ? 'Setup Security PIN' : 'Enter PIN to Unlock',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: index < _pin.length ? const Color(0xFFE8E5A2) : Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE8E5A2), width: 1),
                  ),
                );
              }),
            ),
            const SizedBox(height: 64),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      ["", "0", "⌫"],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: key.isEmpty ? null : () => _onKeyPress(key),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: key.isEmpty ? Colors.transparent : Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      key,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
