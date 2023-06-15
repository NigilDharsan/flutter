import 'package:task/Models/character.dart';
import 'package:task/Screens/CharacterDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/BLoC/character_bloc.dart';

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _speciesFilterController =
      TextEditingController();

  bool _isLoading = false;
  List<Character> _allCharacters = [];
  List<Character> _characters = [];
  int _page = 1;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameFilterController.dispose();
    _speciesFilterController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _fetchCharacters();
    }
  }

  Future<void> _fetchCharacters() async {
    if (_isLoading || !_hasNextPage) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final nameFilter = _nameFilterController.text.trim();
      final speciesFilter = _speciesFilterController.text.trim();
      print("object: ${nameFilter}, ${speciesFilter}");

      final characters = await context.read<CharacterBloc>().fetchCharacters(
            nameFilter: nameFilter.isEmpty ? null : nameFilter,
            speciesFilter: speciesFilter.isEmpty ? null : speciesFilter,
            page: _page,
          );

      setState(() {
        _isLoading = false;
        _allCharacters.addAll(characters);
        _characters = _allCharacters.take(_page * 20).toList();
        _page++;
        _hasNextPage = characters.length >= 20;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  void _applyFilters() {
    setState(() {
      _allCharacters.clear();
      _characters.clear();
      _page = 1;
      _hasNextPage = true;
    });
    _fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Characters')),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return _alertDialogBox();
                },
              );
            },
          ),
        ],
      ),
      body: _buildCharacterList(),
    );
  }

//ALERT DIALOG BOX
  Widget _alertDialogBox() {
    return AlertDialog(
      title: Text('Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameFilterController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: _speciesFilterController,
            decoration: InputDecoration(hintText: 'Species'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _applyFilters();
            Navigator.of(context).pop();
          },
          child: Text('Apply'),
        ),
      ],
    );
  }

//LIST OF DATA
  Widget _buildCharacterList() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: _characters.length + 1,
        itemBuilder: (context, index) {
          if (index < _characters.length) {
            final character = _characters[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: _characterImg(character),
                title: Text(
                  character.name,
                  style: _name,
                ),
                subtitle: Text(
                  character.species,
                  style: _type,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CharacterDetailScreen(character: character),
                    ),
                  );
                },
              ),
            );
          } else if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SizedBox.shrink();
          }
        },
        controller: _scrollController,
      ),
    );
  }

  // CHARACTER IMAGE
  Widget _characterImg(Character character) {
    return Container(
      height: 100,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(character.image), fit: BoxFit.fill)),
    );
  }

  TextStyle _name = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle _type = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
