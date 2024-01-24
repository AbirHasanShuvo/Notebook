
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_need/db_helper.dart';
import 'package:note_need/model.dart';

class SheetContent extends StatefulWidget {
  const SheetContent({super.key, required this.refreshJournal});

  final void Function() refreshJournal;



  @override
  State<SheetContent> createState() =>
      _SheetContentState(refreshJournal: refreshJournal);
}

class _SheetContentState extends State<SheetContent> {
  _SheetContentState({required this.refreshJournal});

  DateTime now = DateTime.now();


  final void Function() refreshJournal;

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();



  Category _selectedCategory = Category.Violet;

  Future<void> saveData() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Empty Field'),
                content:
                    const Text('Title and Description both should be entered'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Okay'))
                ],
              )
      );
      return;
    }

    String s1 = '';
    int val = 0;

    // print(_selectedCategory.toString());

    switch (_selectedCategory.toString()) {
      case 'Category.Red':
        {
          s1 = 'Red';
          val = Colors.red.shade100.value;
          break;
        }

      case 'Category.Blue':
        {
          s1 = 'Blue';
          val = Colors.blue.shade100.value;
          break;
        }

      case 'Category.Green':
        {
          s1 = 'Green';
          val = Colors.green.shade100.value;
          break;
        }
      case 'Category.Orange':
        {
          s1 = 'Orange';
          val = Colors.orange.shade100.value;
          break;
        }
      case 'Category.Yellow':
        {
          s1 = 'Yellow';
          val = Colors.yellow.shade100.value;
          break;
        }
      case 'Category.Grey':
        {
          s1 = 'Grey';
          val = Colors.grey.shade100.value;
          break;
        }
      case 'Category.Violet':
        {
          s1 = 'Violet';
          val = Colors.lightBlueAccent.shade100.value;
          break;
        }

      case 'Category.Green':
        {
          s1 = 'Green';
          val = Colors.white60.value;
          break;
        }

      default:
        {
          s1 = 'Grey';
          val = Colors.grey.value;
        }
    }

    await SQLHelper.createData(
        s1, _titleController.text, _descriptionController.text, val, DateFormat.yMMMEd().format(now));

    refreshJournal();

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;





    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  //const Spacer(),
                   Text('Background: ', style: TextStyle(
                     fontFamily: GoogleFonts.lato().fontFamily,
                     fontSize: 17
                   ),),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {

                          return;
                        }

                        setState(() {
                          _selectedCategory = value;
                        });
                        //print(value.toString());
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
                controller: _titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(
                  fontFamily: GoogleFonts.workSans().fontFamily,
                ),
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Description',

                ),
                maxLines: 6,
                minLines: 4,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',  style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      //fontSize: 14
                    ),),
                  ),
                  ElevatedButton(
                    onPressed: saveData,
                    child:  Text('Save Note',  style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.bold
                      //fontSize: 14
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
