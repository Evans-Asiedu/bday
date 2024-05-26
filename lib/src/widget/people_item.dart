import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bdayapp/src/models/person_model.dart';
import 'package:bdayapp/src/utils/line_painter.dart';
import 'package:bdayapp/src/utils/text_util.dart';
import 'dart:convert';
import 'package:bdayapp/src/values/colors.dart';

// ignore: must_be_immutable
class PeopleItem extends StatelessWidget {
  final Person person;
  final String searchKeyword;

  int daysToBirthday = -1;
  int strLen = 0;
  String showBirthDate = "";

  PeopleItem({super.key,
    required this.person,
    required this.searchKeyword,
  });

  final formatDate = DateFormat('dd MMMM yyyy');

  Map<int, String> daysToBirthdayMap = <int, String>{
    0: "Today",
    1: "Tomorrow",
    2: "2 days more",
    3: "3 days more"
  };


  @override
  Widget build(BuildContext context){
    strLen = person.dateOfBirth.length;
    showBirthDate = person.dateOfBirth.substring(0, (strLen -4));


    DateTime birthdayDate = formatDate.parse(person.dateOfBirth);
    DateTime derivedBirthDate = DateTime(DateTime.now().year, birthdayDate.month,
        birthdayDate.day).add(const Duration(days: 1));

    DateTime currentDate = DateTime.now();

    if(currentDate.isBefore(derivedBirthDate)){
      Duration difference = derivedBirthDate.difference(currentDate);
      daysToBirthday = difference.inDays;
    }

    return CustomPaint(
      painter: LinePainter(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: GestureDetector(
          onTap: (){
          },
          // ignore: unrelated_type_equality_checks
          child: person.photoOfPerson == ""
              ? Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),

            ),
            child: Icon(Icons.account_circle, size: 30, color: Colors.black.withOpacity(0.1),),
          )
              :CircleAvatar(
            radius: 30.0,
            backgroundImage: MemoryImage(base64Decode(person.photoOfPerson)),
          ),
        ),
        // ignore: unrelated_type_equality_checks
        title: searchKeyword == "" || searchKeyword.isEmpty
            ? Text(
          person.name,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        )
            : TextHelpers.getHighlightedText(
          person.name,
          searchKeyword,
          const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                showBirthDate
              //person.dateOfBirth.substring(0, (strlen-4)),
              //formatDate.format(person.dateOfBirth),
            ),
            Text(
                person.relationship
            ),
          ],
        ),

        trailing: daysToBirthday < 4 ?
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            daysToBirthday < 0 ? const Text(""):
            Text(
              daysToBirthdayMap[daysToBirthday]!,
              style: const TextStyle(
                color: notificationBadgeColor,
              ),
            ),
            daysToBirthday < 1 ? const Text("") :
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: notificationBadgeColor,
              ),
              width: 20.0,
              height: 20.0,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 4.0, top: 4.0),
              child: Text(
                daysToBirthday.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ): null,
        onTap: null,
      ),
    );
  }
}
