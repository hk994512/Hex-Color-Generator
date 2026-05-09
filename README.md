# Hex Color Generator

A simple and elegant Flutter application for generating, displaying, and managing random hexadecimal colors.

## 📱 Overview

Hex Color Generator is a utility application that helps users generate random colors in hexadecimal format, view them in real-time, copy color codes, and build custom color palettes.

## 🎯 Features

- 🎨 Generate random hex colors
- 📋 Copy color codes to clipboard
- 🎭 Display colors with preview
- 💾 Save favorite colors
- 🎯 Lock specific colors
- 📊 Color history
- 🌈 Multiple color formats (Hex, RGB, HSL)
- 🔄 Bulk generation

## 📁 Project Structure

```
Hex-Color-Generator/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── color_model.dart
│   │   └── palette_model.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── palette_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── color_card.dart
│   │   ├── color_preview.dart
│   │   └── action_buttons.dart
│   ├── services/
│   │   ├── color_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       ├── colors.dart
│       └── extensions.dart
├── assets/
│   └── icons/
├── pubspec.yaml
└── README.md
```

## 🔧 Prerequisites

- **Flutter SDK** (version 2.0+)
- **Dart SDK**
- Android Studio or Xcode
- Git

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/hk994512/Hex-Color-Generator.git
   cd Hex-Color-Generator
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🚀 Getting Started

### Basic Color Generation

```dart
import 'dart:math';

String generateRandomHexColor() {
  Random random = Random();
  int color = random.nextInt(0xFFFFFFFF);
  return '#${color.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
```

### Color Model

```dart
class ColorModel {
  String hex;
  DateTime createdAt;
  bool isFavorite;

  ColorModel({
    required this.hex,
    DateTime? createdAt,
    this.isFavorite = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Color toFlutterColor() {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }

  String toRgb() {
    Color color = toFlutterColor();
    return 'rgb(${color.red}, ${color.green}, ${color.blue})';
  }

  String toHsl() {
    Color color = toFlutterColor();
    // Convert RGB to HSL
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;
    
    double max = [r, g, b].reduce((a, b) => a > b ? a : b);
    double min = [r, g, b].reduce((a, b) => a < b ? a : b);
    double l = (max + min) / 2;
    
    if (max == min) {
      return 'hsl(0, 0%, ${(l * 100).toStringAsFixed(1)}%)';
    }
    
    double d = max - min;
    double s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    double h = 0;
    
    if (max == r) h = (g - b) / d + (g < b ? 6 : 0);
    else if (max == g) h = (b - r) / d + 2;
    else if (max == b) h = (r - g) / d + 4;
    h /= 6;
    
    return 'hsl(${(h * 360).toStringAsFixed(0)}, ${(s * 100).toStringAsFixed(1)}%, ${(l * 100).toStringAsFixed(1)}%)';
  }
}
```

### Color Service

```dart
class ColorService {
  List<ColorModel> colors = [];
  
  void generateRandomColor() {
    colors.add(ColorModel(hex: generateRandomHexColor()));
  }
  
  void generateMultipleColors(int count) {
    for (int i = 0; i < count; i++) {
      generateRandomColor();
    }
  }
  
  void toggleFavorite(int index) {
    colors[index].isFavorite = !colors[index].isFavorite;
  }
  
  List<ColorModel> getFavorites() {
    return colors.where((color) => color.isFavorite).toList();
  }
  
  void copyToClipboard(String hex) {
    Clipboard.setData(ClipboardData(text: hex));
  }
}
```

### UI Implementation

```dart
class ColorCard extends StatelessWidget {
  final ColorModel color;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;

  const ColorCard({
    required this.color,
    required this.onCopy,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: color.toFlutterColor(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  color.hex,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(color.toRgb(), style: TextStyle(fontSize: 12)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: onCopy,
                      child: Text('Copy'),
                    ),
                    ElevatedButton(
                      onPressed: onFavorite,
                      child: Text(color.isFavorite ? 'Unfavorite' : 'Favorite'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🎨 Color Formats

### Hexadecimal (Hex)
```
#FF5733
```

### RGB
```
rgb(255, 87, 51)
```

### HSL
```
hsl(11, 100%, 60%)
```

## 📚 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0              # State management
  flutter_colorpicker: ^1.0.0   # Color picker widget
  share_plus: ^4.0.0            # Share functionality
  clipboard: ^0.1.3             # Clipboard operations
  hive: ^2.2.0                  # Local storage
```

## 🛠️ Advanced Features

### Lock Colors
```dart
class LockedColor {
  ColorModel color;
  bool isLocked;
  
  LockedColor({required this.color, this.isLocked = false});
}

// Generate with locked colors
void generateWithLockedColors(List<LockedColor> colors) {
  for (int i = 0; i < colors.length; i++) {
    if (!colors[i].isLocked) {
      colors[i].color = ColorModel(hex: generateRandomHexColor());
    }
  }
}
```

### Palette Management
```dart
class Palette {
  String name;
  List<ColorModel> colors;
  DateTime createdAt;
  
  Palette({
    required this.name,
    required this.colors,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  String toCss() {
    return colors.map((c) => c.hex).join(', ');
  }
}
```

## 📊 Features in Detail

### Generate Colors
- Single color generation
- Bulk generation (5, 10, 20 colors)
- Customizable color ranges

### Color Management
- Copy to clipboard
- Save favorites
- View history
- Delete colors

### Export Options
- CSS
- JSON
- Image
- Share

## 🎯 Use Cases

- 🎨 UI/UX Design
- 🖌️ Art Projects
- 💻 Web Development
- 📱 App Design
- 🎮 Game Development

## 🔄 Workflow

1. **Generate** - Create random colors
2. **Preview** - See colors in real-time
3. **Copy** - Get hex code
4. **Save** - Add to favorites
5. **Export** - Share or download

## 🚀 Performance Tips

- Use const constructors
- Implement efficient UI rebuilds
- Cache color calculations
- Use lazy loading for history

## 🤝 Contributing

Contributions welcome!

1. Fork the repository
2. Create a feature branch
3. Make improvements
4. Submit a Pull Request

## 📝 License

MIT License - See LICENSE file

## 👤 Author

**Usama (hk994512)**
- GitHub: [@hk994512](https://github.com/hk994512)

## 📚 Resources

- [Color Theory](https://en.wikipedia.org/wiki/Color_theory)
- [Hex Color Reference](https://www.color-hex.com/)
- [CSS Colors](https://developer.mozilla.org/en-US/docs/Web/CSS/color)
- [Material Design Colors](https://material.io/design/color/)

## 🐛 Troubleshooting

### Colors Not Generating
- Check Random seed
- Verify color format
- Clear app cache

### Copy Not Working
- Verify clipboard permission
- Check device clipboard
- Restart app

## 📞 Support

For issues: [GitHub Issues](https://github.com/hk994512/Hex-Color-Generator/issues)

---

**Create Beautiful Color Palettes! 🎨**