import 'dart:math';
import 'package:colors_generator/extensions/exten.dart';

import '/constants/colors.dart';

import '/helpers/ui_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _randomColor = getRandomColor();
  bool _isHoveringCopyButton = false;
  bool _isHoveringColorBox = false;
  Color? _hoverColor;

  void _incrementCounter() {
    setState(() {
      _randomColor = getRandomColor();
    });
  }

  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  void _copyColorToClipboard(String hexColor) {
    Clipboard.setData(ClipboardData(text: hexColor));
    context.showAlert('Copied $hexColor to clipboard');
  }

  bool useLightText(Color color) {
    return color.computeLuminance() < 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final String hexColor =
        '#${_randomColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final Color hoverTextColor =
        useLightText(_randomColor) ? AppColors.white : AppColors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _randomColor,
        title: UiHelper.text(widget.title),
        foregroundColor:
            useLightText(_randomColor) ? AppColors.white : AppColors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            30.0.ht,
            MouseRegion(
              onEnter:
                  (_) => setState(() {
                    _isHoveringColorBox = true;
                    _hoverColor = _randomColor.withOpacity(0.8);
                  }),
              onExit:
                  (_) => setState(() {
                    _isHoveringColorBox = false;
                    _hoverColor = null;
                  }),
              child: GestureDetector(
                onTap: () => _copyColorToClipboard(hexColor),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _hoverColor ?? _randomColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UiHelper.text(
                          'HEX: $hexColor',
                          color:
                              useLightText(_hoverColor ?? _randomColor)
                                  ? AppColors.white
                                  : AppColors.black,
                          weight: FontWeight.bold,
                        ),

                        if (_isHoveringColorBox)
                          UiHelper.text(
                            'Click to copy',
                            color:
                                useLightText(_hoverColor ?? _randomColor)
                                    ? AppColors.white.withOpacity(0.8)
                                    : AppColors.black.withOpacity(0.8),
                            fontSize: 12,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            20.0.ht,
            // Copy button with hover effect
            MouseRegion(
              onEnter: (_) => setState(() => _isHoveringCopyButton = true),
              onExit: (_) => setState(() => _isHoveringCopyButton = false),
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.copy,
                  color: _isHoveringCopyButton ? hoverTextColor : _randomColor,
                ),

                label: UiHelper.text(
                  'Copy Color',
                  color: _isHoveringCopyButton ? hoverTextColor : _randomColor,
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isHoveringCopyButton
                          ? _randomColor.withOpacity(0.2)
                          : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: _randomColor, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _copyColorToClipboard(hexColor),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _randomColor,
        onPressed: _incrementCounter,
        tooltip: 'Generate New Color',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
