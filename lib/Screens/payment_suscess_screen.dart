import 'package:flutter/material.dart';
import 'package:safe_ship/Screens/home_screen.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

import 'map_screen.dart';

class paymentSucess extends StatefulWidget {
  const paymentSucess({super.key});

  @override
  State<paymentSucess> createState() => _paymentSucessState();
}

class _paymentSucessState extends State<paymentSucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Your Payment was Done Successfully',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ),
          const Image(
            image: AssetImage('assets/sucess.gif'),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'To track you order click on Track Order',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '     OK     ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      context.navigateToScreen(
                          isReplace: true, child: HomeScreen());
                    },
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '     Track Order     ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: (){context.navigateToScreen(isReplace: true, child: MapScreen());},
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
