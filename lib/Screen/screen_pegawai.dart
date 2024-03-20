import 'dart:convert';

import 'package:appberita/Screen/screen_detailpeg.dart';
import 'package:appberita/Screen/screen_editPeg.dart';
import 'package:appberita/Screen/screen_insertpeg.dart';
import 'package:appberita/util/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({Key? key}) : super(key: key);

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  List alluser = [];
  List filteredUsers = []; // Daftar user yang sudah difilter
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  Future<void> getAllUser() async {
    String urlAllUser = "$url/getPegawai.php";
    try {
      var response = await http.get(Uri.parse(urlAllUser));
      setState(() {
        alluser = jsonDecode(response.body);
        filteredUsers = alluser; // Set filteredUsers sama dengan alluser
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUser(String id) async {
    String urlDeleteUser = "$url/deletePeg.php";
    try {
      var responseDel = await http.post(Uri.parse(urlDeleteUser), body: {
        "id": id,
      });
      var delUser = jsonDecode(responseDel.body);
      if (delUser["success"] == "true") {
        print("hapus data Pegawai berhasil");
        getAllUser();
      } else {
        print("hapus data Pegawai berhasil");
      }
    } catch (e) {
      print(e);
    }
  }

  // Fungsi untuk melakukan pencarian
  void searchUser(String query) {
    List searchResult = alluser
        .where(
            (user) => user["nama"].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredUsers = searchResult;
    });
  }

  Future<void> refreshData() async {
    await getAllUser(); // Panggil fungsi untuk mengambil data terbaru
    setState(() {}); // Memperbarui state untuk memicu pembangunan ulang widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Menavigasi ke halaman sebelumnya
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'All Pegawai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged:
                  searchUser, // Panggil fungsi searchUser saat teks berubah
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length, // Gunakan filteredUsers
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      // Navigasi ke halaman detail pegawai saat ListTile diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPegawai(pegawai: filteredUsers[index]),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.red,
                    ),
                    title: Text(
                      filteredUsers[index]["nama"],
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      filteredUsers[index]["email"],
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPegawai(
                                      pegawai: filteredUsers[index]),
                                ));
                            refreshData();
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 24,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteUser(filteredUsers[index]["id"]);
                            getAllUser();
                          },
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            size: 24,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => InsertPeg()));
        },
        splashColor: Colors.blue,
        backgroundColor: Colors.blue.shade900,
        mini: true,
        child: const Icon(
          Icons.add,
          size: 24,
        ),
      ),
    );
  }
}
