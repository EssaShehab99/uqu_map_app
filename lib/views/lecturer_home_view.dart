import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_home/admin_home.dart';
import 'package:uqu_map_app/views/CommonScreens/map_view_screen/map_view_screen.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_home/lecturer_home.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';

class LecturerHomeView extends StatefulWidget {
  const LecturerHomeView({Key? key}) : super(key: key);

  @override
  _LecturerHomeViewState createState() => _LecturerHomeViewState();
}

class _LecturerHomeViewState extends State<LecturerHomeView> {

  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late int _currentIndex;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _page1 = const MapViewScreen();
    _page2 = const LecturerHome();
    _page3 = Text('');
    _pages = [_page1, _page2, _page3];
    _currentIndex = 1;
    _currentPage = _page2;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if(index == 2){
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }else{
              _changeTab(index);
            }

          },
          currentIndex: _currentIndex,
          backgroundColor: AppColor.appThemeColor,
          selectedItemColor: AppColor.kPrimaryColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Lecture',
              icon: Icon(Icons.home_repair_service),
            ),
            BottomNavigationBarItem(
              label: 'Exit',
              icon: Icon(Icons.person),
            ),

          ]),
    );
  }

  Widget _navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        '$title Page',
        style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        _changeTab(index);
      },
    );
  }
}
