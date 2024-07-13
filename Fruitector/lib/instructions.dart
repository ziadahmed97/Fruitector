import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'http.dart';

class InstructionScreen extends StatefulWidget {
  @override
  _InstructionScreenState createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              InstructionPage(
                image: 'assets/images/inst1.png',
                buttonText: 'Next',
                buttonText2: 'skip',
                buttonAction: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                buttonPrevAction: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage())),
              ),
              InstructionPage2(
                image: 'assets/images/inst2.png',
                buttonText: 'Next',
                buttonText2: 'Previous',
                buttonAction: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                buttonPrevAction: () => _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
              ),
              InstructionPage3(
                image: 'assets/images/inst3.png',
                buttonText2: 'Previous',
                buttonPrevAction: () => _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                buttonAction: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage())),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 650, 0, 0),
            child: DotsIndicator(
              dotsCount: 3,
              position: _currentPage.toDouble(),
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: Color(0XFF246D48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionPage extends StatelessWidget {
  final String image;
  final String buttonText;
  final String buttonText2;
  final VoidCallback buttonAction;
  final VoidCallback buttonPrevAction;

  InstructionPage(
      {required this.image,
      required this.buttonText,
      required this.buttonAction,
      required this.buttonPrevAction,
      required this.buttonText2});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF246D48),
    ));
    return SafeArea(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
            child: Image.asset(
              image,
              height: 504,
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Step 1",
                style: TextStyle(
                    color: Color(0XFF246D48),
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter'),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Please place the targeted fruit \non a white board",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0XFF404040),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inder'),
              )
            ],
          ),
          SizedBox(height: 110),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: buttonPrevAction,
                  child: Text(
                    buttonText2,
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontFamily: 'RobotoFlex',
                        fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: buttonAction,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        color: Color(0xFF246D48),
                        fontFamily: 'RobotoFlex',
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InstructionPage2 extends StatelessWidget {
  final String image;
  final String buttonText;
  final String buttonText2;
  final VoidCallback buttonAction;
  final VoidCallback buttonPrevAction;

  InstructionPage2(
      {required this.image,
      required this.buttonText,
      required this.buttonAction,
      required this.buttonPrevAction,
      required this.buttonText2});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF246D48),
    ));
    return SafeArea(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
            child: Image.asset(
              image,
              height: 504,
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Step 2",
                style: TextStyle(
                    color: Color(0XFF246D48),
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter'),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Please adjust the light on the \nfruit by 50°",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0XFF404040),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inder'),
              )
            ],
          ),
          SizedBox(height: 110),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: buttonPrevAction,
                  child: Text(
                    buttonText2,
                    style: TextStyle(
                        color: Color(0xFF246D48),
                        fontFamily: 'RobotoFlex',
                        fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: buttonAction,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        color: Color(0xFF246D48),
                        fontFamily: 'RobotoFlex',
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InstructionPage3 extends StatelessWidget {
  final String image;
  final String buttonText2;
  final VoidCallback buttonPrevAction;
  final VoidCallback buttonAction;

  InstructionPage3(
      {required this.image,
      required this.buttonText2,
      required this.buttonAction,
      required this.buttonPrevAction});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF246D48), // Set status bar color
    ));
    return SafeArea(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
            child: Image.asset(
              image,
              height: 504,
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Step 3",
                style: TextStyle(
                    color: Color(0XFF246D48),
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter'),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Determine which side of the targeted fruit \nyou will capture",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0XFF404040),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inder'),
              )
            ],
          ),
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: buttonPrevAction,
                  child: Text(
                    buttonText2,
                    style: TextStyle(
                        color: Color(0xFF246D48),
                        fontFamily: 'RobotoFlex',
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  width: 220,
                ),
                ElevatedButton(
                  onPressed: buttonAction,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF246D48)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
