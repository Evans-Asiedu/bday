import 'package:fluro/fluro.dart';
import 'package:bdayapp/src/home.dart';
import 'package:bdayapp/src/screens/add_person_screen.dart';
import 'package:bdayapp/src/models/person_model.dart';
import 'dart:convert';


var rootHandler = Handler(
  handlerFunc: (context, params){
    return const Home();
  }
);

var addNewPersonHandler = Handler(
    handlerFunc: (context, params){
      List maps = params["person"]!;
      var value = maps[0];
      var map = json.decode(value);
      Person person = Person.fromMap(map);
      return NewPersonPage(person: person);
    }
);


