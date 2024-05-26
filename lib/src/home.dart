// ignore_for_file: library_private_types_in_public_api

import 'package:bdayapp/src/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:bdayapp/src/screens/home_screen/people.dart';

enum HomeOptions{
  sortByName,
  rate,
  about
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _actionButtons = [];
  List<PopupMenuItem<HomeOptions>> _popupMenus = [];

  late bool _isSearching;
  late TextField _searchBar;
  late TextEditingController _searchBarController;
  late bool _searchBarOpen;
  String _searchKeyword = '';

  @override
  void initState(){
    super.initState();

    //initiating variables
    _isSearching = false;

    _searchBarController = TextEditingController();
    _searchBarController.addListener(() {
      setState(() {
        _searchKeyword = _searchBarController.text;
      });
    });

    _searchBar = TextField(
      cursorColor: primaryColor,
      controller: _searchBarController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'search...',
        border: InputBorder.none,
      )
    );

    // defining action buttons
    _actionButtons = <Widget>[
      IconButton(
        tooltip: "Search",
        icon: const Icon(Icons.search),
        onPressed: (){
          setState(() {
            _searchBarOpen = true;
            _isSearching = true;
            _searchBarController?.text = "";
          });
        },
      ),

      PopupMenuButton<HomeOptions>(
        tooltip: "More options",
        onSelected: _selectOption,
        itemBuilder: (BuildContext context){
          return _popupMenus;
        },
      ),

    ];


    // defining popupmenu buttons
    _popupMenus = [
      // popup menu items
      const PopupMenuItem(
          value: HomeOptions.sortByName,
          child: Text("Sort by Name"),
      ),

      const PopupMenuItem(
        value: HomeOptions.rate,
        child: Text("Rate"),
      ),

      const PopupMenuItem(
        value: HomeOptions.about,
        child: Text("About"),
      ),
    ];
  }


  // functions
  void _selectOption(HomeOptions option){
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_searchBarOpen){
          setState(() {
            _searchBarOpen = false;
            _isSearching = false;
            _searchBarController?.text = "";
          });
          return false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _isSearching
              ? Colors.green : primaryColor,

          leading: _isSearching
            ? IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xff075e54),
            onPressed: () {
              _searchBarOpen = true;
              _isSearching = false;
              _searchBarController?.text = "";
            },
          ) : null,

          title: _isSearching
            ? _searchBar : const Text("BDay"),

          actions: _isSearching ? null : _actionButtons,
        ),

        body: People(
          searchKeyword: _searchKeyword,
        ),
      ),
    );
  }

  @override
  void dispose(){
    _searchBarController.dispose();
    super.dispose();
  }
}

