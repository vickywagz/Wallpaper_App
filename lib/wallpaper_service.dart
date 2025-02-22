import 'dart:convert';
import 'package:http/http.dart' as http;

class WallpaperService {
  static const String apiKey =
      '5YYVOSFPwiEFcKwdyhUFwGZAoogDccF9tecRYrnjwlA43IE1PLKx7qIi';
  static const String baseUrl =
      'https://api.pexels.com/v1/search?query=wallpapers&per_page=45';

  static Future<List<String>> fetchWallpapers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> imageUrls = List<String>.from(
          data['photos'].map((photo) => photo['src']['large']));
      return imageUrls;
    } else {
      throw Exception('Failed to load wallpaper');
    }
  }
}
