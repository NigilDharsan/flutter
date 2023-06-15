import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://rickandmortyapi.com/api';

  Future<Map<String, dynamic>> fetchCharacters({
    String? nameFilter,
    String? statusFilter,
    String? speciesFilter,
    int page = 1,
  }) async {
    final String url = '$baseUrl/character';
    final Map<String, String> queryParams = {
      'page': page.toString(),
      if (nameFilter != null) 'name': nameFilter,
      if (statusFilter != null) 'status': statusFilter,
      if (speciesFilter != null) 'species': speciesFilter,
    };

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch characters');
    }
  }
}
