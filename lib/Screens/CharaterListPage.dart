import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:task/Screens/CharacterDetailScreen.dart';
import 'package:task/Screens/FilterScreen.dart';

class CharaterListPage extends StatefulWidget {
  CharaterListPage({super.key});

  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharaterListPage> {
  List<dynamic> characters = [];

  String? nameFilter;
  String? statusFilter;
  String? speciesFilter;

  int page = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  List<dynamic> allCharacters = [];

  @override
  void initState() {
    super.initState();
    fetchCharacters();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchCharacters();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchCharacters() async {
    if (isLoading) return;
    isLoading = true;

    if (page == 1) {
      try {
        final file = await DefaultCacheManager().getSingleFile(
          'https://rickandmortyapi.com/api/character',
          key: 'rick_and_morty_characters',
        );
        final data = jsonDecode(file.readAsStringSync());
        final List<dynamic> newCharacters = data['results'];
        setState(() {
          allCharacters.addAll(newCharacters);
          characters = allCharacters;
          page++;
          isLoading = false;
        });
      } catch (e) {
        print('Error loading characters from cache: $e');
        isLoading = false;
      }
    } else {
      if (!await checkInternetConnection()) {
        print('No internet connection');
        isLoading = false;
        return;
      }

      final uri = Uri.https('rickandmortyapi.com', '/api/character', {
        'name': nameFilter ?? '',
        'status': statusFilter ?? '',
        'species': speciesFilter ?? '',
        'page': page.toString(),
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> newCharacters = data['results'];
        setState(() {
          allCharacters.addAll(newCharacters);
          characters = allCharacters;
          page++;
          isLoading = false;
        });
      } else {
        print('Error loading characters from API: ${response.statusCode}');
        isLoading = false;
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick & Morty Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => FilterScreen(
                    onApplyFilters: (name, status, species) {
                      setState(() {
                        nameFilter = name;
                        statusFilter = status;
                        speciesFilter = species;
                        page = 1;
                        allCharacters.clear();
                        characters.clear();
                      });
                      fetchCharacters();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                _scrollController.position.extentAfter == 0) {
              fetchCharacters();
            }
            return false;
          },
          child: _buildCharacterList()),
    );
  }

  Widget _buildCharacterList() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: characters.length + 1,
        itemBuilder: (context, index) {
          if (index < characters.length) {
            final character = characters[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: _characterImg(character["image"]),
                title: Text(
                  character['name'],
                  style: _name,
                ),
                subtitle: Text(
                  character['species'],
                  style: _type,
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         CharacterDetailScreen(character: character),
                  //   ),
                  // );
                },
              ),
            );
          } else {
            return ListTile(
              title: Center(child: CircularProgressIndicator()),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }

  Widget _characterImg(String image) {
    return Container(
      height: 100,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
    );
  }

  TextStyle _name = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle _type = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
