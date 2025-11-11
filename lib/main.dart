import 'package:flutter/material.dart';
import 'package:flutter_notesapplication/features/auth/login_screen.dart';
import 'package:flutter_notesapplication/features/notes/screens/notes_home_screen.dart';
import 'package:flutter_notesapplication/services/local_storage.dart';




void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: InitialScreen()
    );
  }
}
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isLoading=true;
  bool _isLoggedIn=false;

  @override
  void initState() {


  
    super.initState();
    checkLoginStatus();
  }

  Future<void>checkLoginStatus()async{
    final loggedIn=await LocalStorage.isLoggedIn();
    setState(() {
      _isLoggedIn=loggedIn;
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_isLoading){
       return Scaffold(body: Center(
        child: CircularProgressIndicator(),
      ),);

    }
    return _isLoggedIn? const NotesHomeScreen(): const LoginScreen();
    
     
    
  }

  }
