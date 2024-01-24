import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_need/model.dart';
import 'package:intl/intl.dart';
import 'package:note_need/db_helper.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.category,
    required this.refreshJournals

  });

  final Map<String, dynamic> category;
  final Function() refreshJournals;
  //final Function? heightSum;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);
    GlobalKey _key = GlobalKey();

    Future<void> deleteItem(int id) async{
      await SQLHelper.deleteItem(id);
      refreshJournals();
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(
        content: Text('Deleted Successfully'),
      ));
    }

    return InkWell(
      splashColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        key: _key,
        //height: 100,
        height: (MediaQuery.of(context).size.height * 0.23),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(colors: [
              Color(category['color']).withOpacity(0.7),
              Color(category['color']).withOpacity(0.5),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),

        //color: Color(category['color']),

        child: Column(
          children: [
            Text(
              category['title'],
              style: TextStyle(
                fontSize: 17,
                fontFamily: GoogleFonts.anton().fontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              category['description'],
              //overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                fontFamily: GoogleFonts.workSans().fontFamily
              ),
            ),
            const Spacer(),
            Text(category['date'],
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.lato().fontFamily
              ),
            ),
            //const Spacer(),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text('Deleting'),
                                content: const Text(
                                    'Are you want to delete this note ? '),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No')),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        deleteItem(category['id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes')),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
