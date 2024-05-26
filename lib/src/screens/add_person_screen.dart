// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/person_model.dart';
import 'package:bdayapp/src/utils/size_config.dart';
import 'package:bdayapp/src/database/db_handler.dart';
import 'package:bdayapp/src/utils/date_selector.dart';
// import 'package:bdayapp/src/utils/image_util.dart';

import '../values/colors.dart';



class NewPersonPage extends StatefulWidget {
  final Person person;

  const NewPersonPage({Key? key, required this.person}) : super(key: key);

  @override
  _NewPersonPageState createState() => _NewPersonPageState();
}

class _NewPersonPageState extends State<NewPersonPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _relationship = <String>[];


  late DBHandler dbHandler;

  late String showBirthDate;

  late String _birthdayDate;
  late String _photoOfPerson;
  late String _relationshipType;

  final formatDate = DateFormat('dd MMMM yyyy');

  late DateTime birthdayDate;
  late int _selectedMonth;
  late int _selectedDay;
  late int strLen;


  static final TextStyle _textSize = TextStyle(
    fontSize: 3.7 * SizeConfig.safeBlockHorizontal,
  );

  @override
  void initState(){
    super.initState();
    dbHandler = DBHandler.db;
    _nameController.text = widget.person.name;
    _birthdayDate = widget.person.dateOfBirth;
    _photoOfPerson = widget.person.photoOfPerson;

    strLen = widget.person.dateOfBirth.length;

    _relationship.addAll(["Father", "Mother", "Sister", "Brother", "Husband",
      "Wife", "Son", "Daughter", "Friend", "Customer", "Relative"]);

    _relationshipType = widget.person.relationship == "" ? _relationship[0]
        : widget.person.relationship ;

     _selectedDay = 0;
     _selectedMonth = 1;
  }


  //functions
  void _reset(){
    setState(() {
      // ignore: unrelated_type_equality_checks
      _nameController.text = "";
      _birthdayDate = "";
      _photoOfPerson = "";
      _relationshipType = _relationship[0];
      showBirthDate = "";
    });
  }

  bool isFormValid(){
    if(_nameController.text.isEmpty || _birthdayDate == "" || _relationshipType == ""){
      displayDialog("Title", "Message");
      return false;
    }
    return true;
  }

  void displayDialog(title, message){
    var alert = AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 20.0),),
      content: Text(message, style: _textSize,),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ]
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _savePerson(Person person) async{
    if(isFormValid()){
      var id = person.id;
      person = Person(
        name: _nameController.text,
        dateOfBirth: _birthdayDate,
        photoOfPerson: _photoOfPerson,
        relationship: _relationshipType,
      );

      if(id == null) {
        await dbHandler.addPerson(person);
      } else {
        await dbHandler.editPerson(person, id);
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void _pickDate(){
    var alert = AlertDialog(
      contentPadding: const EdgeInsets.all(5.0),
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: DateSelector(
          selectedMonth: _selectedMonth,
          selectedDay: _selectedDay,
          onDateSelected: (Map month, int day){
            setState(() {
              _selectedMonth = month['number'];
              _selectedDay = day;
              birthdayDate = DateTime(DateTime.now().year, _selectedMonth, _selectedDay);
              _birthdayDate = formatDate.format(birthdayDate);
              strLen = _birthdayDate.length;
              showBirthDate = _birthdayDate.substring(0, (strLen - 4));
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  void _removePickedImage(){
    setState(() {
      _photoOfPerson = "";
    });
  }

  // needs to look at the function again and make some changes
  /*
  void _pickImage(ImageSource source) async{
    var imageFile = await ImagePicker.pickImage(source: source);
    setState(() {
      _photoOfPerson = Utility.base64String(imageFile.readAsBytes());
    });
  }
  */

  void _showModelSheet(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: 250.0,
            width: 200,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 20.0, 0, 40.0),
                  child: Text(
                    "Person Photo",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.photo_library),
                            onPressed: (){
                              Navigator.of(context).pop();
                              //_pickImage(ImageSource.gallery);
                            }
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Gallery",
                          style: _textSize,//TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.delete),
                          onPressed:(){
                            Navigator.of(context).pop();
                            _removePickedImage();},
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Remove Photo",
                          style: _textSize, //TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  void _onChangedDropDown(String value){
    setState(() {
      _relationshipType = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              onPressed: _reset,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text(
                "Cancel",
                style: _textSize,
              ),
            ),
            ElevatedButton(
              onPressed: () {_savePerson(widget.person);},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child:  Text(
                "Save",
                style: _textSize,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 90),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _imagePicked(),
                  Positioned(
                    right: SizeConfig.safeBlockHorizontal * 29.55,
                    bottom: -3,
                    child: FloatingActionButton.small(
                      onPressed: _showModelSheet,
                      backgroundColor: highlightColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.camera_alt, ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _formField(_nameController, "Enter Full Name"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _birthdayRow(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: _relationshipRow(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }    // end of build widget

  // widgets
  Widget _imagePicked(){
    // ignore: unrelated_type_equality_checks
    if(_photoOfPerson == Null){
      return CircleAvatar(
        radius: SizeConfig.safeBlockHorizontal * 20.44,
        backgroundColor: Colors.black.withOpacity(0.1),
      );
    }

    return CircleAvatar(
      radius: SizeConfig.safeBlockHorizontal * 12.44, //70,
      // backgroundImage: MemoryImage(base64Decode(_photoOfPerson)),
    );
  }

  Widget _formField(TextEditingController textEditingController, String text){
    return TextFormField(
      cursorColor: primaryColor,
      style: _textSize,
      controller: textEditingController,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.account_circle, color: primaryColor,),
        labelText: text,
        labelStyle: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 2.8,
          color: primaryColor,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _birthdayRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:<Widget>[
        Text(
          "Birthday Date:",
          style: _textSize,
        ),
        TextButton(
          onPressed: null,
          child: Text(
            // ignore: unrelated_type_equality_checks
            _birthdayDate == "" ? "No Date Selected" : _birthdayDate.substring(0, strLen-4), // correction needs to be done
            style: TextStyle(
              fontSize: 3.7 * SizeConfig.safeBlockHorizontal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _pickDate,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Text(
            "Select Date",
            style: _textSize,
          ),
        ),
      ],
    );
  }

  Widget _relationshipRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Relationship",
          style: _textSize,
        ),
        const SizedBox(
          width: 40,
        ),
        DropdownButton(
          value: _relationshipType,
          items: _relationship.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: _textSize,
              ),
            );
          }).toList(),
          onChanged: (String? newValue){
            _onChangedDropDown(newValue!);//would have to check it again
          },
        ),
      ],
    );
  }

}
