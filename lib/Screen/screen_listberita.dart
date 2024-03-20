import 'dart:convert';

import 'package:appberita/Screen/screen_pegawai.dart';
import 'package:appberita/model/model_berita.dart';
import 'package:appberita/screen/screen_login.dart';
import 'package:appberita/util/check_session.dart';
import 'package:appberita/util/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageListBerita extends StatefulWidget {
  const PageListBerita({super.key});

  @override
  State<PageListBerita> createState() => __PageListBeritaState();
}

class __PageListBeritaState extends State<PageListBerita> {
  String? id;
  bool isLoading = true;
  bool isCari = false;
  List<String> filterData = [];
  List<Welcome> listBerita = [];
  TextEditingController txtcari = TextEditingController();

  __PageListBeritaState() {
    txtcari.addListener(() {
      if (txtcari.text.isEmpty) {
        setState(() {
          isCari = true;
          txtcari.text = '';
        });
      } else {
        setState(() {
          isCari = false;
          txtcari.text != "";
        });
      }
    });
  }

  // id = session.get
  Future getBerita() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getBerita.php'));
      var data = jsonDecode(res.body);
      setState(() {
        for (Map<String, dynamic> i in data) {
          listBerita.add(Welcome.fromJson(i));
        }
      });

      // http.Response res = await http.get(Uri.parse('$url/getBerita.php'));
      // return welcomeFromJson(res.body).data;
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Berita",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  session.clearSession();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                });
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PegawaiPage()),
                );
              },
              icon: Icon(
                Icons.person_2_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
              controller: txtcari,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.search, size: 20),
                ),
                hintText: "Search",
                hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.blue.shade100,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          isCari
              ? Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: ListView.builder(
                            itemCount: listBerita.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Welcome? data = listBerita[index];
                                    ;
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(
                                            seconds:
                                                0), // Set duration to 0 to disable animation
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return detilberita(data);
                                        },
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(12),
                                    // shape: Border(bottom: BorderSide(width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              '$url/gambar_berita/${listBerita[index].gambarBerita}',
                                              width: double.infinity,
                                              height:
                                                  300, // Sesuaikan ukuran gambar sesuai kebutuhan
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Jarak antara gambar dan judul
                                            Text(
                                              '${listBerita[index].judul}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    5), // Jarak antara judul dan isi berita
                                            Text(
                                              "${listBerita[index].isiBerita}",
                                              style: TextStyle(fontSize: 14),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                )
              : createFilterList()
        ],
      ),
    );
  }

  Widget createFilterList() {
    List<Welcome> filteredList = listBerita.where((berita) {
      return berita.judul.toLowerCase().contains(txtcari.text.toLowerCase());
    }).toList();

    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      Welcome? data = filteredList[index];
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return detilberita(data);
                          },
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(12),
                      // shape: Border(bottom: BorderSide(width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                '$url/gambar_berita/${filteredList[index].gambarBerita}',
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${filteredList[index].judul}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${filteredList[index].isiBerita}",
                                style: TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class detilberita extends StatelessWidget {
  final Welcome? data;

  const detilberita(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${data?.judul}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Image.network('$url/gambar_berita/${data?.gambarBerita}'),
              Text(
                '${data?.judul}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                '${data?.tglBerita}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                '${data?.isiBerita}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
