import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/screens/activity_screen.dart';
import 'package:quickie_mobile/screens/home_screen.dart';
import 'package:quickie_mobile/screens/profile_screen.dart';
import 'package:quickie_mobile/screens/search_screen.dart';

import '../providers/bottom_navbar_provider.dart';
import 'newthread_screen.dart';
class DashBoardScreen extends StatelessWidget {
   DashBoardScreen({super.key});

 final  List<Widget>screens=[
   HomeScreen(),
   SearchScreen(),
   NewThreadScreen(),
   ActivityScreen(),
   ProfileScreen(),
 ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavbarProvider>(
        builder: (context,provider,child){
          return screens[provider.index];
        },


      ),
      bottomNavigationBar:BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: buildicon(0,const Icon(CupertinoIcons.home),const Icon(CupertinoIcons.house_fill)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: buildicon(1,const Icon(CupertinoIcons.search),const Icon(CupertinoIcons.search)),
            ),

            Padding(
              padding: const EdgeInsets.all(5),
              child: buildicon(2,const Icon(Icons.edit_note),const Icon(Icons.edit_note)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: buildicon(3,const Icon(CupertinoIcons.heart),const Icon(CupertinoIcons.heart_fill)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: buildicon(4,const Icon(CupertinoIcons.person),const Icon(CupertinoIcons.person_fill)),
            ),

          ],
        ),
      ),





    );
  }
  Widget buildicon(var index,icon,selectedicon){


    return  Consumer<NavbarProvider>(
        builder: (context,provider,child){
      final isSelected=provider.index==index;
      return  IconTheme(
          data: IconThemeData(
              color:isSelected? Theme.of(context).primaryColor:Colors.grey

          ),
          child: IconButton(onPressed: (){
            context.read<NavbarProvider>().changeIndex(index);



          }, icon:isSelected?selectedicon: icon));
    },


    );



  }
}
