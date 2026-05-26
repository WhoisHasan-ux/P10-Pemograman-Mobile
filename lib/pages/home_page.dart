import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

//membuat state untuk home page
  @override
  State<HomePage> createState() => _HomePageState();
}


//membuat class state untuk home page
class _HomePageState extends State<HomePage> {
  //inisialisasi variabel username
  String username = '';

  //membuat init state untuk mengambil data username dari shared preferences
  @override
  void initState() {
    super.initState();
    getUser();
  }

  //membuat method getUser untuk mengambil data username dari shared preferences(lokal storage)
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  //Membuat method Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

//membuat widget builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const NetworkImage('https://picsum.photos/seed/picsum/536/354'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 228, 231, 233),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ]
                      )
                    ]
                  )
                ),
                ElevatedButton(
                  onPressed: logout,
                  child: Icon(Icons.logout, color: const Color.fromARGB(255, 200, 15, 15), size: 16),
                )
              ]
            )
          )
        ),
      ),
    );
  }

}