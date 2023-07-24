import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/color.dart';
import 'package:flutter_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController city = TextEditingController();
  String country = 'India';
  colorProvider prov = colorProvider();

  @override
  void initState() {
    prov = Provider.of<colorProvider>(context, listen: false);
    super.initState();
    getData();
  }

  getData() async {
    var res =
        await FirebaseFirestore.instance.collection("data").doc("sample").get();
    name = TextEditingController(text: res['name']);
    mobile = TextEditingController(text: res['mobile']);
    email = TextEditingController(text: res['email']);
    city = TextEditingController(text: res['city']);
    country = res['country'];
    prov.updateColor(country);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print(width);
    return Consumer<colorProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: value.color,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              "PetukJi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Center(
            child: Container(
              width: width > 700 && width<1000 ? 3 * width / 4 : width >= 1000 ? width/2 : width,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: name,
                        name: "Name",
                        inputType: TextInputType.name,
                        color: value.color,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        controller: mobile,
                        name: "Mobile",
                        inputType: TextInputType.phone,
                        color: value.color,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        controller: email,
                        name: "Email",
                        inputType: TextInputType.emailAddress,
                        color: value.color,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        controller: city,
                        name: "City",
                        inputType: TextInputType.text,
                        color: value.color,
                      ),
                      const SizedBox(height: 25),
                      DropdownButtonFormField(
                        value: country,
                        decoration: InputDecoration(
                          hintText: "Country",
                          labelText: "Country",
                          hintStyle: TextStyle(color: value.color),
                          labelStyle: TextStyle(color: value.color),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: value.color,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: value.color,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: value.color,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: value.color,
                              width: 1,
                            ),
                          ),
                        ),
                        items: ['India', 'Pakistan', 'Australia'].map((e) {
                          return DropdownMenuItem(
                            child: SingleChildScrollView(
                              child: Text(e),
                            ),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            country = newValue!;
                          });
                          prov.updateColor(country);
                        },
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setDataToFirebase();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: value.color,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              "SET",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void setDataToFirebase() async {
    if (name.text.isNotEmpty &&
        mobile.text.isNotEmpty &&
        email.text.isNotEmpty &&
        city.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("data").doc("sample").update({
        'name': name.text,
        'mobile': mobile.text,
        'email': email.text,
        'city': city.text,
        'country': country,
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Updated new Data to Firestore"),
          ),
        );
        getData();
        prov.updateColor(country);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fields should not empty"),
        ),
      );
    }
  }
}
