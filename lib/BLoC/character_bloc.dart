import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/Models/character.dart';
import 'package:task/Repository/character_repository.dart';

class CharacterEvent {
  final String? nameFilter;
  final String? speciesFilter;

  CharacterEvent({this.nameFilter, this.speciesFilter});
}

class CharacterState {}

class InitialState extends CharacterState {}

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;

  CharacterBloc(this.characterRepository) : super(InitialState());

  Future<List<Character>> fetchCharacters({
    String? nameFilter,
    String? speciesFilter,
    int page = 1,
  }) async {
    try {
      final characters = await characterRepository.fetchCharacters(
        nameFilter: nameFilter,
        speciesFilter: speciesFilter,
        page: page,
      );
      return characters;
    } catch (error) {
      // Handle error
      throw Exception('Failed to fetch characters: $error');
    }
  }
}
