import 'package:task/ApiService/api_service.dart';
import 'package:task/Models/character.dart';

class CharacterRepository {
  final ApiService apiService;

  CharacterRepository(this.apiService);

  Future<List<Character>> fetchCharacters({
    String? nameFilter,
    String? statusFilter,
    String? speciesFilter,
    int page = 1,
  }) async {
    final response = await apiService.fetchCharacters(
      nameFilter: nameFilter,
      statusFilter: statusFilter,
      speciesFilter: speciesFilter,
      page: page,
    );
    final List<dynamic> data = response['results'];
    final List<Character> characters =
        data.map((characterData) => Character.fromJson(characterData)).toList();
    return characters;
  }
}
