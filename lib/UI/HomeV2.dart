import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:neon/neon.dart';
const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color(0xff242830);

class PietPainting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 1,
        rowGap: 1,
        areas: '''
           R Y 
           R Y 
           R Y 
        
        ''',
        // A number of extension methods are provided for concise track sizing
        columnSizes: [ 1.2.fr, 1.2.fr],
        rowSizes: [
          1.0.fr,
          1.3.fr,
          1.5.fr,
         
        ],
        children: [
          // Column 1
        //  gridArea('r').containing(Container(color: cellRed)),
      //    gridArea('y').containing(Container(color: cellMustard)),
          // Column 2
          gridArea('R').containing(Container(color: Colors.yellow, child: Center(child: Text("Announcements") ,))),
          // Column 3
       //   gridArea('B').containing(Container(color: cellBlue)),
          gridArea('Y').containing(Container(color: Colors.orangeAccent)),
      //    gridArea('g').containing(Container(color: cellGrey)),
          // Column 4
       //   gridArea('b').containing(Container(color: cellBlue)),
          // Column 5
      //    gridArea('yy').containing(Container(color: cellMustard)),
        ],
      ),
    );
  }
}

class PietNamedAreasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
     // title: 'Layout Grid Desktop Example',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => PietPainting(),
    );
  }
}