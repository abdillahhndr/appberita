import 'package:appberita/Screen/screen_pegawai.dart';
import 'package:appberita/util/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertPeg extends StatefulWidget {
  @override
  _InsertPegState createState() => _InsertPegState();
}

class _InsertPegState extends State<InsertPeg> {
  TextEditingController namaController = TextEditingController();
  TextEditingController noBpController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  Future<void> addPegawai() async {
    String urlInsertPegawai =
        "$url/insertPeg.php"; // Ganti URL dengan URL API Anda
    try {
      var response = await http.post(
        Uri.parse(urlInsertPegawai),
        body: {
          'nama': namaController.text,
          'no_bp': noBpController.text,
          'no_hp': noHpController.text,
          'email': emailController.text,
        },
      );
      // Handle response here
      print(response.body);
      // Clear input fields after successful insertion
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pegawai'),
        backgroundColor: Color.fromARGB(255, 33, 72, 243),
      ),
      body: Center(
        child: Form(
          key: keyForm,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: namaController,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                      labelText: "nama",
                      hintText: "nama",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: noBpController,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                      labelText: "NoBp",
                      hintText: "NoBp",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: noHpController,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                      labelText: "NoHp",
                      hintText: "NoHp",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    if (keyForm.currentState?.validate() == true) {
                      addPegawai();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PegawaiPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("silahkan isi data terlebih dahulu")));
                    }
                  },
                  color: Color.fromARGB(255, 33, 72, 243),
                  textColor: Colors.white,
                  height: 45,
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
