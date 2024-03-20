import 'dart:convert';

import 'package:appberita/util/url.dart';
import 'package:flutter/material.dart';
import 'package:appberita/model/model_berita.dart';
import 'package:http/http.dart' as http;

class GaleryPage extends StatefulWidget {
  const GaleryPage({super.key});

  @override
  State<GaleryPage> createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage> {
  bool isLoading = true;
  List<Welcome> listBerita = [];

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
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GridView.builder(
          itemCount: listBerita.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                //untuk ke page detail ketika salah satu gambar d klik
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageDetilGall(
                              '${listBerita[index].gambarBerita}',
                            )));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GridTile(
                  footer: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  child: Image.network(
                    '$url/gambar_berita/${listBerita[index].gambarBerita}',
                    fit: BoxFit.contain,
                    height: 185,
                    width: 185,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class PageDetilGall extends StatelessWidget {
  //penampung data
  final String itemGambar;
  const PageDetilGall(this.itemGambar, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.network(
                  '$url/gambar_berita/$itemGambar',
                  fit: BoxFit.contain,
                  height: 500,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
