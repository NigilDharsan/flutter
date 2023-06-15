import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/Models/character.dart';
import 'package:task/Repository/character_repository.dart';

class CharacterEvent {
  final String? nameFilter;
  final String? speciesFilter;

  CharacterEvent({this.nameFilter, this.speciesFilter});
}

// class FetchCharactersEvent extends CharacterEvent {
//   final String? nameFilter;
//   final String? statusFilter;
//   final String? speciesFilter;
//   final int page;

//   FetchCharactersEvent({
//     this.nameFilter,
//     this.statusFilter,
//     this.speciesFilter,
//     required this.page,
//   }) : super(
//             nameFilter: nameFilter,
//             statusFilter: statusFilter,
//             speciesFilter: speciesFilter);
// }

class CharacterState {}

class InitialState extends CharacterState {}

// class LoadingState extends CharacterState {}

// class CharactersLoadedState extends CharacterState {
//   final List<Character> characters;

//   CharactersLoadedState(this.characters);
// }

// class CharacterErrorState extends CharacterState {
//   final String errorMessage;

//   CharacterErrorState(this.errorMessage);
// }

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

  // @override
  // Stream<CharacterState> mapEventToState(CharacterEvent event) async* {
  //   if (event is FetchCharactersEvent) {
  //     yield LoadingState();
  //     try {
  //       final characters = await fetchCharacters(
  //         nameFilter: event.nameFilter,
  //         statusFilter: event.statusFilter,
  //         speciesFilter: event.speciesFilter,
  //         page: event.page,
  //       );
  //       yield CharactersLoadedState(characters);
  //     } catch (error) {
  //       yield CharacterErrorState('Failed to fetch characters: $error');
  //     }
  //   }
  // }
}
