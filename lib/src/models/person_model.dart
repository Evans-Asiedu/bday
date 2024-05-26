// import 'package:intl/intl.dart';

class Person{
  //final formatDate = DateFormat('dd MMMM yyyy');
  int? id;
  late String name = "";
  late String dateOfBirth = "";
  late String photoOfPerson = "";
  late String relationship = "";

  Person({
    required this.name,
    required this.dateOfBirth,
    required this.photoOfPerson,
    required this.relationship,
  });

  Person.empty();

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'name': name,
      'dateOfBirth': dateOfBirth,
      'photoOfPerson': photoOfPerson,
      'relationship': relationship
    };

    // ignore: unrelated_type_equality_checks
    if(id != null) map['id'] = id;

    return map;
  }

  Person.fromMap(Map person){
    id = person['id'];
    name = person['name'];
    dateOfBirth = person['dateOfBirth'];
    photoOfPerson = person['photoOfPerson'];
    relationship = person['relationship'];
  }

}