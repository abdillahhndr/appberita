import 'package:appberita/Screen/screen_edtiprofile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageProfil extends StatefulWidget {
  const PageProfil({super.key});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  String? id, username;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print(id);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 72, 243),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "lib/assets/profil.png",
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "$username",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                // Text(
                //   "user@gmail.com",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.normal,
                //       fontSize: 18),
                // ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                  // '$id',
                                  // '$username',
                                  )));
                    },
                    child: Text('Edit Profile'),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    side: BorderSide(color: Colors.white))))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Expanded(
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(25),
          //             topRight: Radius.circular(25))),
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 50),
          //       child: Container(
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(25),
          //                 topRight: Radius.circular(25))),
          //         child: ListView.builder(
          //             // itemCount: listKamus.length,
          //             itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 5),
          //             child: GestureDetector(
          //               onTap: () {},
          //               // child: Card(
          //               //   margin: EdgeInsets.all(12),
          //               //   // shape: Border(bottom: BorderSide(width: 1)),
          //               //   child: Padding(
          //               //     padding: const EdgeInsets.all(10),
          //               //   ),
          //               // ),
          //             ),
          //           );
          //         }),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
