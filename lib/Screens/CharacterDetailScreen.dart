import 'package:flutter/material.dart';
import 'package:task/Models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  CharacterDetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            _characterImg(),
            _characterName(),
            _characterSpecies(), // Add more character details here
          ],
        ),
      ),
    );
  }

  //CHARACTER IMAGE
  Widget _characterImg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: NetworkImage(character.image))),
        ),
      ],
    );
  }

//CHARACTER NAME
  Widget _characterName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        character.name,
        style: _name,
      ),
    );
  }

//CHARACTER SPECIES NAME
  Widget _characterSpecies() {
    return Text(
      "(${character.species})",
      style: _type,
    );
  }

  TextStyle _name = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle _type = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
