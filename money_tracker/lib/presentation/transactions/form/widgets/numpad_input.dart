import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';

class NumpadInput extends StatefulWidget {
  final double initialAmount;
  final Color accentColor;

  const NumpadInput({
    super.key,
    this.initialAmount = 0,
    this.accentColor = AppColors.primary,
  });

  static Future<double?> show(
    BuildContext context, {
    double initialAmount = 0,
    Color accentColor = AppColors.primary,
  }) {
    return showGeneralDialog<double>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Numpad',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim, secondAnim, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => NumpadInput(
        initialAmount: initialAmount,
        accentColor: accentColor,
      ),
    );
  }

  @override
  State<NumpadInput> createState() => _NumpadInputState();
}

class _NumpadInputState extends State<NumpadInput> {
  late String _display;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount > 0) {
      _display = widget.initialAmount.toStringAsFixed(
        widget.initialAmount == widget.initialAmount.truncateToDouble() ? 0 : 2,
      );
    } else {
      _display = '0';
    }
  }

  void _onDigit(String digit) {
    setState(() {
      if (_display == '0' && digit != '.') {
        _display = digit;
      } else if (digit == '.' && _display.contains('.')) {
        // Don't allow multiple dots
      } else if (_display.contains('.') &&
          _display.split('.').last.length >= 2) {
        // Limit to 2 decimal places
      } else if (_display.length < 15) {
        _display += digit;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onConfirm() {
    final value = double.tryParse(_display) ?? 0;
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final parsedAmount = double.tryParse(_display) ?? 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            // Amount display
            Text(
              CurrencyFormatter.format(parsedAmount),
              style: AppTextStyles.display.copyWith(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _display,
              style: AppTextStyles.body.copyWith(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Numpad grid
            ..._buildRows(),
            const SizedBox(height: 12),
            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'OK',
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return keys.map((row) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildKey(key),
              ),
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  Widget _buildKey(String key) {
    final isBackspace = key == '⌫';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isBackspace) {
            _onBackspace();
          } else {
            _onDigit(key);
          }
        },
        onLongPress: isBackspace ? () => setState(() => _display = '0') : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: isBackspace
              ? const Icon(Icons.backspace_outlined,
                  color: Colors.white70, size: 24)
              : Text(
                  key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
