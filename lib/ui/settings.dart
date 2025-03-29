import 'package:flutter/material.dart';
import 'package:purecord/api/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../api/apidata.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color customAccent;
  bool verifyQRLogin = true;
  bool outlineButtons = true;
  bool useCompression = true;
  bool fakeNitro = false;
  bool showQRCodeScanner = false;
  bool isProcessingQR = false;
  
  @override
  void initState() {
    super.initState();
    customAccent = const Color(0xFF6750A4);
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final int? colorValue = prefs.getInt('custom_accent');
      if (colorValue != null) {
        customAccent = Color(colorValue);
      } else {
        customAccent = Theme.of(context).colorScheme.primaryContainer;
      }
      verifyQRLogin = prefs.getBool('verify_qr_code') ?? true;
      outlineButtons = prefs.getBool('outline_buttons') ?? true;
      useCompression = prefs.getBool('use_compression') ?? true;
      fakeNitro = prefs.getBool('fake_nitro') ?? false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('custom_accent', customAccent.value);
    prefs.setBool('verify_qr_code', verifyQRLogin);
    prefs.setBool('outline_buttons', outlineButtons);
    prefs.setBool('use_compression', useCompression);
    prefs.setBool('fake_nitro', fakeNitro);
  }
  
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Accent Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: customAccent,
              onColorChanged: (Color color) {
                setState(() {
                  customAccent = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _openQRScanner() {
    setState(() {
      showQRCodeScanner = true;
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QRScannerSheet(
        onClose: () {
          setState(() {
            showQRCodeScanner = false;
          });
          Navigator.pop(context);
        },
        onQRDetected: (String qrData) async {
          isProcessingQR = true;
          if (qrData.contains("https://discord.com/")) {
            final tempToken = await Api.remoteAuthStage1(qrData.split("/").last);
            if (tempToken != null) {
              await Api.remoteAuthStage2(tempToken);
              return true;
            }
          }
          isProcessingQR = false;
          return false;
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Settings"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                customAccent.withOpacity(0.3),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Account Settings"),
              _buildSettingsGroup([
                _buildNavItem(
                  icon: Icons.account_circle,
                  title: "Account",
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AccountSettingsPage())
                  ),
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.shield,
                  title: "Privacy & Safety",
                  onTap: () {},
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.key,
                  title: "Authorized Apps",
                  onTap: () {},
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.laptop_mac,
                  title: "Devices",
                  onTap: () {},
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.extension,
                  title: "Connections",
                  onTap: () {},
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.qr_code,
                  title: "Scan QR Code",
                  onTap: _openQRScanner,
                ),
              ]),
              
              _buildSectionTitle("PureCord Settings"),
              _buildSettingsGroup([
                _buildNavItem(
                  icon: Icons.auto_fix_high,
                  title: "PureCord",
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PureCordSettingsPage())
                  ),
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.extension_outlined,
                  title: "PureCord Extensions",
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PureCordExtensionsPage())
                  ),
                ),
              ]),
              
              _buildSectionTitle("Nitro Settings"),
              _buildSettingsGroup([
                _buildNavItem(
                  icon: Icons.star_border,
                  title: "Manage Nitro",
                  onTap: () {},
                ),
                ColorDivider(color: customAccent),
                _buildNavItem(
                  icon: Icons.auto_awesome,
                  title: "Server Boosts",
                  onTap: () {},
                ),
              ]),
              
              _buildSettingsGroup([
                _buildNavItem(
                  icon: Icons.logout,
                  title: "Log Out",
                  onTap: () {
                    Api.setToken(null);
                  },
                  showChevron: false,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
  
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: customAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: outlineButtons ? Border.all(color: customAccent) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class ColorDivider extends StatelessWidget {
  final Color color;
  final double height;
  
  const ColorDivider({
    super.key,
    required this.color,
    this.height = 0.5,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: color,
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiData = Provider.of<ApiData>(context);
    final user = apiData.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: user == null 
        ? const Center(child: CircularProgressIndicator())
        : const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account Info",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class PureCordSettingsPage extends StatefulWidget {
  @override
  _PureCordSettingsPageState createState() => _PureCordSettingsPageState();
}

class _PureCordSettingsPageState extends State<PureCordSettingsPage> {
  late Color customAccent;
  bool verifyQRLogin = true;
  bool outlineButtons = true;
  bool useCompression = true;
  
  @override
  void initState() {
    super.initState();
    customAccent = const Color(0xFF6750A4);
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final int colorValue = prefs.getInt('custom_accent') ?? 0xFF6750A4;
      customAccent = Color(colorValue);
      verifyQRLogin = prefs.getBool('verify_qr_code') ?? true;
      outlineButtons = prefs.getBool('outline_buttons') ?? true;
      useCompression = prefs.getBool('use_compression') ?? true;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('custom_accent', customAccent.value);
    prefs.setBool('verify_qr_code', verifyQRLogin);
    prefs.setBool('outline_buttons', outlineButtons);
    prefs.setBool('use_compression', useCompression);
  }
  
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Accent Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: customAccent,
              onColorChanged: (Color color) {
                setState(() {
                  customAccent = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PureCord Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: customAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: outlineButtons 
                    ? Border.all(color: customAccent) 
                    : null,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "Accent Color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: _openColorPicker,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: customAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      onTap: _openColorPicker,
                    ),
                    ColorDivider(color: customAccent),
                    SwitchListTile(
                      title: const Text(
                        "Verify QR Code Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: verifyQRLogin,
                      activeColor: customAccent,
                      onChanged: (value) {
                        setState(() {
                          verifyQRLogin = value;
                          _saveSettings();
                        });
                      },
                    ),
                    ColorDivider(color: customAccent),
                    SwitchListTile(
                      title: const Text(
                        "Outline Buttons",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: outlineButtons,
                      activeColor: customAccent,
                      onChanged: (value) {
                        setState(() {
                          outlineButtons = value;
                          _saveSettings();
                        });
                      },
                    ),
                    ColorDivider(color: customAccent),
                    SwitchListTile(
                      title: const Text(
                        "Use Websocket Compression",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: useCompression,
                      activeColor: customAccent,
                      onChanged: (value) {
                        setState(() {
                          useCompression = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PureCordExtensionsPage extends StatefulWidget {
  @override
  _PureCordExtensionsPageState createState() => _PureCordExtensionsPageState();
}

class _PureCordExtensionsPageState extends State<PureCordExtensionsPage> {
  late Color customAccent;
  bool outlineButtons = true;
  bool fakeNitro = false;
  
  @override
  void initState() {
    super.initState();
    customAccent = const Color(0xFF6750A4);
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final int colorValue = prefs.getInt('custom_accent') ?? 0xFF6750A4;
      customAccent = Color(colorValue);
      outlineButtons = prefs.getBool('outline_buttons') ?? true;
      fakeNitro = prefs.getBool('fake_nitro') ?? false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('fake_nitro', fakeNitro);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PureCord Extensions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Extensions",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: customAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: outlineButtons 
                    ? Border.all(color: customAccent) 
                    : null,
                ),
                child: SwitchListTile(
                  title: const Text(
                    "Fake Nitro",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  value: fakeNitro,
                  activeColor: customAccent,
                  onChanged: (value) {
                    setState(() {
                      fakeNitro = value;
                      _saveSettings();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRScannerSheet extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onQRDetected;

  const QRScannerSheet({
    Key? key,
    required this.onClose,
    required this.onQRDetected,
  }) : super(key: key);

  @override
  State<QRScannerSheet> createState() => _QRScannerSheetState();
}

class _QRScannerSheetState extends State<QRScannerSheet> {
  late MobileScannerController controller;
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scan QR Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null && isScanning) {
                      final String qrData = barcode.rawValue!;
                      
                      final shouldStop = widget.onQRDetected(qrData);
                      
                      if (shouldStop) {
                        setState(() {
                          isScanning = false;
                        });
                        widget.onClose();
                        break;
                      }
                    }
                  }
                },
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Position the QR code within the scan area',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}