import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidebar/flutter_sidebar.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:infinityhub/States/ThemeState.dart';
import 'package:infinityhub/UI/HomeV2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../TaskUpdatePage.dart';
import 'GroupChat.dart';

class MyHomePage1 extends StatefulWidget {
  String herotag;
  MyHomePage1(this.herotag);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1>
    with SingleTickerProviderStateMixin {
  static const _mobileThreshold = 700.0;
  bool isMobile = false;
  bool sidebarOpen = false;
  bool canBeDragged = false;
  var isverified;
  GlobalKey _sidebarKey;

  AnimationController _animationController;
  Animation _animation;

  final List<Map<String, dynamic>> tabData = [
    {'title': 'Announcements'},
    {'title': 'Chart Board'},
    {'title': 'Task Updates'},
    {
      'title': 'Chats',
      'children': [
        {'title': 'Group Chat'},
        {'title': 'Private Chat'},
      ],
    },
    {
      'title': 'Settings',
    },
  ];
  String tab;
  void setTab(String newTab) {
    setState(() {
      tab = newTab;
    });
    maincontent(tab);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      print(FirebaseAuth.instance.currentUser.displayName.toString());
    });

    _sidebarKey = GlobalKey();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuad);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    setState(() {
      isMobile = mediaQuery.size.width < _mobileThreshold;
      sidebarOpen = !isMobile;
      _animationController.value = isMobile ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      sidebarOpen = !sidebarOpen;
      if (sidebarOpen)
        _animationController.forward();
      else
        _animationController.reverse();
    });
  }

  void onDragStart(DragStartDetails details) {
    bool isClosed = _animationController.isDismissed;
    bool isOpen = _animationController.isCompleted;
    canBeDragged = (isClosed && details.globalPosition.dx < 60) || isOpen;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (canBeDragged) {
      double delta = details.primaryDelta / 300;
      _animationController.value += delta;
    }
  }

  void dragCloseDrawer(DragUpdateDetails details) {
    double delta = details.primaryDelta;
    if (delta < 0) {
      sidebarOpen = false;
      _animationController.reverse();
    }
  }

  void onDragEnd(DragEndDetails details) async {
    double _kMinFlingVelocity = 365.0;

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / 300;

      await _animationController.fling(velocity: visualVelocity);
      if (_animationController.isCompleted) {
        setState(() {
          sidebarOpen = true;
        });
      } else {
        setState(() {
          sidebarOpen = false;
        });
      }
    } else {
      if (_animationController.value < 0.5) {
        _animationController.reverse();
        setState(() {
          sidebarOpen = false;
        });
      } else {
        _animationController.forward();
        setState(() {
          sidebarOpen = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(fontSize: 26);
    final sidebar = Sidebar.fromJson(
      key: _sidebarKey,
      tabs: tabData,
      onTabChanged: setTab,
    );
    /*  final mainContent = 
    
    
    Center(
      child: tab != null
          ? Text.rich(
              TextSpan(
                text: 'Selected tab: ',
                style: _textStyle,
                children: [
                  TextSpan(
                    text: '$tab',
                    style: _textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    
                  ),
                  
                ],
              ),
            )
          : Text(
              'No tab selected',
              style: _textStyle,
            ),
    );*/

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.dashboard_rounded), onPressed: _toggleSidebar),
          title: Hero(
              tag: widget.herotag, child: Image.asset("assets/IHLogo.png")),
          centerTitle: true,
          actions: [
            FlutterSwitch(
              width: 100.0,
              height: 45.0,
              toggleSize: 45.0,
              value: Provider.of<ThemeState>(context).theme == ThemeType.DARK,
              borderRadius: 30.0,
              padding: 2.0,
              activeToggleColor: Color(0xFF6E40C9),
              inactiveToggleColor: Color(0xFF2F363D),
              activeSwitchBorder: Border.all(
                color: Color(0xFF3C1E70),
                width: 6.0,
              ),
              inactiveSwitchBorder: Border.all(
                color: Color(0xFFD1D5DA),
                width: 6.0,
              ),
              activeColor: Color(0xFF271052),
              inactiveColor: Colors.white,
              activeIcon: Icon(
                Icons.nightlight_round,
                color: Color(0xFFF8E3A1),
              ),
              inactiveIcon: Icon(
                Icons.wb_sunny,
                color: Color(0xFFFFDF5D),
              ),
              onToggle: (val) {
                Provider.of<ThemeState>(context, listen: false).theme =
                    val ? ThemeType.DARK : ThemeType.LIGHT;
              },
            ),
            Padding(padding: EdgeInsets.all(10)),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  setState(() {
                    Provider.of<ThemeState>(context, listen: false).theme =
                        ThemeType.LIGHT;
                  });

                  FirebaseAuth.instance
                      .signOut()
                      .then((value) => {print('successfully logout')})
                      .catchError((onError) {});
                })
          ]),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => isMobile
            ? Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragStart: onDragStart,
                    onHorizontalDragUpdate: onDragUpdate,
                    onHorizontalDragEnd: onDragEnd,
                  ),
                  maincontent(tab),
                  if (_animation.value > 0)
                    Container(
                      color: Colors.black
                          .withAlpha((150 * _animation.value).toInt()),
                    ),
                  if (_animation.value == 1)
                    GestureDetector(
                      onTap: _toggleSidebar,
                      onHorizontalDragUpdate: dragCloseDrawer,
                    ),
                  ClipRect(
                    child: SizedOverflowBox(
                      size: Size(300 * _animation.value, double.infinity),
                      child: sidebar,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  ClipRect(
                    child: SizedOverflowBox(
                      size: Size(300 * _animation.value, double.infinity),
                      child: sidebar,
                    ),
                  ),
                  Expanded(
                    child: maincontent(tab),
                  ),
                ],
              ),
      ),
    );
  }

  Widget maincontent(var tabvalue) {
    /* switch (tabvalue) {
      case 'Group Chat':
        return NewHomePage();
        break;
         case 'Announcements':
        return PietNamedAreasApp();
        break;
      default:
      
    }*/
    return tabvalue == 'Group Chat'
        ? NewHomePage()
        : tabvalue == 'Task Updates'
            ? TaskUpdatePage()
            : tabvalue == 'Chart Board'
                ? Container(
                    color: Colors.white,
                    child: Signature(
                      color: Colors.black, // Color of the drawing path
                      strokeWidth: 5.0, // with
                      backgroundPainter:
                          null, // Additional custom painter to draw stuff like watermark
                      onSign: null, // Callback called on user pan drawing
                      key:
                          null, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
                    ))
                : tabvalue == 'Announcements'
                    ? PietPainting()
                    : Container();
  }
}
