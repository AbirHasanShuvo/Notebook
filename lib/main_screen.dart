import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_need/dummy_data.dart';
import 'package:note_need/example.dart';
import 'package:note_need/note_details.dart';
import 'package:note_need/note_item.dart';
import 'package:note_need/db_helper.dart';
import 'package:note_need/sheet_content.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  static const List<(Color?, Color? background, ShapeBorder?)> customizations =
      <(Color?, Color?, ShapeBorder?)>[
    (null, null, null), // The FAB uses its default for null parameters.
    (null, Colors.green, null),
    (Colors.white, Colors.green, null),
    (Colors.white, Colors.green, CircleBorder()),
  ];
  int index = 0; // Selects the customization.

  late final _modalSheetTransitionController = AnimationController(
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 500),
    vsync: this,
  );

  List<Map<String, dynamic>> _journals = [];

  void refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      //_isLoading = false;
      //it is coming from the whole database all values as a map format
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournals();

  }

  void newNote() {
    showModalBottomSheet(
      transitionAnimationController: _modalSheetTransitionController,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        //dynamically it will take 70% of the screen

        child: Center(
            child: SheetContent(
          refreshJournal: refreshJournals,
        )),
      ),
    );
  }

  List<Map<String, dynamic>> _newJournal = [];

  double containerHeight = 1.2;

  void heightInitial(double heightFrom) {
    containerHeight = heightFrom;
  }

  GlobalKey _containerkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMEd().format(now);
    Map<String, dynamic> something;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'All Notes',
          style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            index = (index + 1) % customizations.length;
          });

          newNote();
        },
        foregroundColor: customizations[index].$1,
        backgroundColor: customizations[index].$2,
        shape: customizations[index].$3,
        child: const Icon(Icons.add),
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
          children: [
            for (final dummycategories in _journals.reversed)
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      // how much time when we will go from one to another
                      reverseTransitionDuration:
                          const Duration(milliseconds: 500),
                      // how much time when we will return from one to another
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          NoteDetails(
                        category: dummycategories,
                        refreshJournal: refreshJournals,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0,
                            0.0); //here changing depend on how the page will translate like down to up or left to right
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
                  },
                  child: NoteItem(
                    category: dummycategories,
                    refreshJournals: refreshJournals,
                  ))
          ]),
    );

    /**/
  }
}
