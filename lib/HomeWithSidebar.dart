import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prayaan/Mainmenu/Page3.dart';
import 'Main_Page/Login.dart';
class HomeWithSidebar extends StatelessWidget {
  const HomeWithSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWithSidebar(),
    );
  }
}
class homeWithSidebar extends StatefulWidget {
  @override
  _homeWithSidebarState createState() => _homeWithSidebarState();
}

class _homeWithSidebarState extends State<homeWithSidebar> with TickerProviderStateMixin{
  bool sideBarActive = false;
  late AnimationController rotationController;
  @override
  void initState() {
    // TODO: implement initState

    rotationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
                        color: Colors.white
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                image: DecorationImage(
                                    image: AssetImage('asset/Pic.jpeg'),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Carol Johnson", style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text("Seattle Washington", style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    navigatorTitle("Home", true),
                    navigatorTitle("Profile", false),
                    navigatorTitle("Accounts", false),
                    navigatorTitle("Transactions", false),
                    navigatorTitle("Stats", false),
                    navigatorTitle("Settings", false),
                    navigatorTitle("Help", false),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.power_settings_new,
                      size: 30,
                    ),
                    ListTile(
                        leading: const Icon(Icons.output_outlined),
                        title:  const Text("Sign Out"),

                        onTap: () {showDialog(context: context, builder: (context){
                          return AlertDialog(

                            title: const Text("LogOut"),
                            actions: [
                              TextButton(onPressed: ()=>{
                                FirebaseAuth.instance.signOut(),
                                Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage())
                                ),},
                                child: const Text("yes"),),
                              TextButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Mainmenu()),
                                );
                              },
                                child: const Text("No"),)
                            ],

                          );
                        },
                        );}),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(20),
                child: const Text("Ver 2.0.1",style: TextStyle(
                    color: Colors.grey
                ),),
              )
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: (sideBarActive) ? MediaQuery.of(context).size.width*0.6 : 0,
            top: (sideBarActive)? MediaQuery.of(context).size.height*0.2 : 0,
            child: RotationTransition(
              turns: (sideBarActive) ? Tween(begin: -0.05, end: 0.0).animate(rotationController) : Tween(begin: 0.0, end: -0.05).animate(rotationController),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: (sideBarActive) ? MediaQuery.of(context).size.height*0.7 : MediaQuery.of(context).size.height,
                width: (sideBarActive) ? MediaQuery.of(context).size.width*0.8 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: Mainmenu(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: (sideBarActive) ? IconButton(
              padding: EdgeInsets.all(30),
              onPressed: closeSideBar,
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
            ): InkWell(
              onTap: openSideBar,
              child: Container(
                margin: EdgeInsets.all(17),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('asset/Pic.jpeg')
                    )
                ),
              ),

            ),
          )
        ],
      ),
    );
  }
  Row navigatorTitle(String name, bool isSelected)
  {
    return Row(
      children: [
        (isSelected) ? Container(
          width: 5,
          height: 60,
          color: Color(0xffffac30),
        ):
        Container(width: 5,
          height: 60,),
        SizedBox(width: 10,height: 60,),
        Text(name, style: TextStyle(
            fontSize: 16,
            fontWeight: (isSelected) ? FontWeight.w700: FontWeight.w400
        ),)
      ],
    );
  }
  void closeSideBar()
  {
    sideBarActive = false;
    setState(() {

    });
  }
  void openSideBar()
  {
    sideBarActive = true;
    setState(() {

    });
  }
}