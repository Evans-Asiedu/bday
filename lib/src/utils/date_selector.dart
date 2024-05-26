// ignore_for_file: library_private_types_in_public_api
import 'package:bdayapp/src/utils/months.dart' as mu;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DateSelector extends StatefulWidget {
  final Function onDateSelected;
  final int selectedMonth;
  final int selectedDay;

  const DateSelector({Key? key, required this.onDateSelected,
      required this.selectedMonth, required this.selectedDay}): super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late Map _selectedMonth;
  late int _selectedDay;
  bool _daysView = false;
  final List months = mu.months;

  @override
  void initState() {
    super.initState();
    // ignore: unrelated_type_equality_checks
    if(widget.selectedDay != Null){
      _selectedDay = widget.selectedDay;
      _selectedMonth = mu.findMontByNumber(widget.selectedMonth);
      _daysView = true;
    }
  }

  List<Widget> _buildMonthsGrid(){
    List<Widget> list = <Widget>[];
    for (var month in months) {
      list.add(
        InkWell(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              // ignore: unrelated_type_equality_checks
            color: (_selectedMonth != Null && _selectedMonth['number'] == month['number'])
                    ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 3.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.5
                  ),
                ]
            ),
            child: Center(
                child: Text(
                  "${month['abbreviation']}",
                  style: TextStyle(
                    // ignore: unrelated_type_equality_checks
                  color: (_selectedMonth != Null && _selectedMonth['number'] == month['number'])
                        ? Colors.white : Colors.grey,
                  ),
                )
            ),
          ),
          onTap: (){
            _selectMonth(month);
          },
        ),
      );
    }
    return list;
  }

  void _selectMonth(Map month){
    _selectedMonth = month;
    _selectedDay = 0;
    _daysView = true;
    setState(() {
    });
  }

  Widget buildMonthsWidget(){
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
      children: _buildMonthsGrid(),
    );

  }

  Widget buildDaysWidget(){
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.2,
            mainAxisSpacing: 0.2,
            children: _buildDaysGrid(),
          ),
        ),
        backToMonthsButton()
      ],
    );

  }

  Widget backToMonthsButton(){
    return InkWell(
      child: Container(
        height: 50.0,
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Center(
          child: Text(
            'BACK TO MONTHS',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0
            ),
          ),
        ),
      ),
      onTap: (){
        goBackToMonthsView();
      },
    );
  }

  void goBackToMonthsView(){
    _daysView = false;
    setState(() {
    });
  }

  List<Widget> _buildDaysGrid(){
    var days = _selectedMonth['days'];

    List<Widget> list = <Widget>[];
    for(var i = 1; i <= days; i++){
      list.add(
        InkWell(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                // ignore: unrelated_type_equality_checks
              color: (_selectedDay != Null && _selectedDay == i) ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 3.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.5
                    ),
                  ]

              ),
              child: Center(
                child: Text(
                  '$i',
                  style: TextStyle(
                    // ignore: unrelated_type_equality_checks
                  color: (_selectedDay != Null && _selectedDay == i)
                          ? Colors.white : Colors.grey
                  ),
                ),
              ),
            ),
            onTap: (){
              widget.onDateSelected(_selectedMonth, i);
              setState((){_selectedDay = i;});
            }
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 310.0,
      child: Center(
        child: (!_daysView) ? buildMonthsWidget() : buildDaysWidget(),
      ),
    );
  }
}
