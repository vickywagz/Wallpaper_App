import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Wallpaperviewpage extends StatelessWidget {
  final String imageUrl;

  const Wallpaperviewpage({super.key, required this.imageUrl});

  Future<void> _setWallpaper(int wallpaperType, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/wallpaper.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Set wallpaper
      bool result =
          await WallpaperManager.setWallpaperFromFile(filePath, wallpaperType);

      if (result) {
        Fluttertoast.showToast(
          msg: "Wallpaper set successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        throw Exception("Failed to set wallpaper");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    Navigator.pop(context);
  }

  void _showSetWallpaperOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set Wallpaper",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.white),
                title: const Text("Home Screen",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.HOME_SCREEN,
                      context); // ✅ Pass correct type
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text("Lock Screen",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.LOCK_SCREEN,
                      context); // ✅ Pass correct type
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallpaper, color: Colors.white),
                title: const Text("Both Screens",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.HOME_SCREEN, context);
                  _setWallpaper(WallpaperManager.LOCK_SCREEN,
                      context); // ✅ Pass correct type
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Preview",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => _showSetWallpaperOptions(context),
                  icon: const Icon(Icons.wallpaper, color: Colors.white),
                  label: const Text(
                    "Set as Wallpaper",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
