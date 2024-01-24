import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_need/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:note_need/db_helper.dart';
import 'package:note_need/main_screen.dart';
import 'package:share_plus/share_plus.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails(
      {super.key, required this.category, required this.refreshJournal});

  final Map<String, dynamic> category;
  final Function() refreshJournal;

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController _titlecontroller = new TextEditingController();
  TextEditingController _descriptioncontroller = new TextEditingController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titlecontroller.text = widget.category['title'];
    _descriptioncontroller.text = widget.category['description'];
  }

  Future<void> updateItem(int id) async {
    await SQLHelper.upDateItem(
        id,
        widget.category['type'],
        _titlecontroller.text,
        _descriptioncontroller.text,
        widget.category['color'],
        DateFormat.yMMMEd().format(now));

    widget.refreshJournal();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Saved Successfully'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(widget.category['color']).withOpacity(0.5),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  //String s1 = 'Hello World';
                  Share.share(_descriptioncontroller.text);
                },
                icon: const Icon(Icons.share))
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(widget.category['color']).withOpacity(0.7),
                      //color: Color(widget.category['color']).withOpacity(0.7),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color(widget.category['color']).withOpacity(0.7)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: _titlecontroller,
                    maxLines: 2,
                    minLines: 1,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(widget.category['color']).withOpacity(0.7),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color(widget.category['color']).withOpacity(0.7)),
                child: TextField(
                  style: TextStyle(
                    fontFamily: GoogleFonts.workSans().fontFamily,
                    //fontSize: 14
                  ),
                  controller: _descriptioncontroller,
                  maxLines: null,
                  minLines: 15,
                  decoration: const InputDecoration(
                      //isDense: true,
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(widget.category['color']).withOpacity(0.7)),
                      ),
                      onPressed: () {
                        updateItem(widget.category['id']);
                      },
                      label: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                          //fontSize: 14,
                          fontFamily: GoogleFonts.merriweather().fontFamily,
                        ),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
