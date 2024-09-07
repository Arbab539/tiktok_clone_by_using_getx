import 'package:flutter/material.dart';


import '../../constants.dart';
import '../widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          currentIndex: pageIndex,
          backgroundColor: backgroundColor,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              pageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,size: 30,),
                label: 'Search'
            ),
            BottomNavigationBarItem(
                icon: CustomIcon(),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Message'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]
      ),
      body: pages[pageIndex],
    );
  }
}
