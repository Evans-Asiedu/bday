// ignore_for_file: library_private_types_in_public_api
import 'package:bdayapp/src/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:bdayapp/src/screens/add_person_screen.dart';
import 'package:bdayapp/src/models/person_model.dart';
import 'package:bdayapp/src/database/db_handler.dart';
import 'package:bdayapp/src/widget/people_item.dart';
import 'package:intl/intl.dart';
import 'dart:core';


class People extends StatefulWidget {
  final String searchKeyword;

  const People({super.key,
    required this.searchKeyword
});

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  final List<Person> _persons = <Person>[];
  late final DBHandler dbHandler;
  final formatDate = DateFormat('dd MMMM yyyy');

  List<Person> persons = <Person>[];

  static const _textSize = TextStyle(
    fontSize: 18.0,
  );

  @override
  void initState(){
    super.initState();
    dbHandler = DBHandler.db;
    _loadPersons();
  }

  void _loadPersons() async{
    _persons.clear();
    List <Person> personsFromDB = await dbHandler.getAllPersons();
    setState(() {
      _persons.addAll(personsFromDB);
    });
  }

  void _addPerson() async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewPersonPage(person: Person.empty())
      )
    );

    _loadPersons();
  }

  void _editPerson(Person person) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewPersonPage(person: person)
      )
    );

    _loadPersons();
  }

  void _deletePerson(int id) async {
    await dbHandler.deletePerson(id);
    _loadPersons();
  }

  void _confirmDelete(Person person){
    var alert = AlertDialog(
      title: Text(
        "Delete ${person.name}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      content: Text(
        "Are you sure you want to delete ${person.name}?",
        style: _textSize,
      ),
      actions: [
        TextButton(
          onPressed: (){Navigator.pop(context);},
          child: const Text(
            "No",
            style: _textSize,
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            _deletePerson(person.id!);
          },
          child: const Text(
            "Yes",
            style: _textSize,
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _onLongPressPersonItem(BuildContext context, Person person){
    AlertDialog infoDialog = AlertDialog(
      content: Text("Do you want to edit or delete  ${person.name}?",
        style: _textSize,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Cancel",
            style: _textSize,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
            "Edit",
            style: _textSize,
          ),
          onPressed: (){
            Navigator.pop(context);
            _editPerson(person);
            //
          },
        ),
        TextButton(
          child: const Text(
            "Delete",
            style: _textSize,
          ),
          onPressed: (){
            Navigator.pop(context);
            _confirmDelete(person);
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => infoDialog
    );
  }

  Widget _buildPeopleItem(BuildContext context, searchKeyword, Person person){
    return PeopleItem(
      person: person,
      searchKeyword: searchKeyword,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFound = false;
    persons.clear();
    persons.addAll(_persons);

    return Scaffold(
      body: ListView.builder(
          itemCount: persons.length, // needs to be modified
          itemBuilder: (context, int index){
            if(widget.searchKeyword.isNotEmpty){
              if(!persons[index].name.toLowerCase()
                  .contains(widget.searchKeyword.toLowerCase())){
                if(!isFound && index >= persons.length - 1){
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "No results found for ${widget.searchKeyword}"
                      ),
                    ),
                  );
                }
                return const SizedBox(
                  height: 0.0,
                );
              }
            }
            isFound = true;
            return GestureDetector(
              onLongPress: (){_onLongPressPersonItem(context,  persons[index]);},
              child: _buildPeopleItem(
                context, widget.searchKeyword, persons[index]
              ),
            );
          }
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: FloatingActionButton(
          backgroundColor: fabBgColor,
          foregroundColor: Colors.white,
          onPressed: _addPerson,
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
