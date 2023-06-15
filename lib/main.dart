import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/ApiService/api_service.dart';
import 'package:task/BLoC/character_bloc.dart';
import 'package:task/Repository/character_repository.dart';
import 'package:task/Screens/CharacterListScreen.dart';
import 'package:task/Screens/CharaterListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final CharacterRepository characterRepository =
        CharacterRepository(apiService);
    final CharacterBloc characterBloc = CharacterBloc(characterRepository);

    return MaterialApp(
      title: 'Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<CharacterBloc>(
        create: (BuildContext context) => characterBloc,
        child: CharacterListScreen(), // CharacterListPage()
      ),
    );
  }
}
