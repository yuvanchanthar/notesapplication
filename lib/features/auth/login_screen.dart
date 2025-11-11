import 'package:flutter/material.dart';
import 'package:flutter_notesapplication/features/notes/screens/notes_home_screen.dart';


import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  String _errorMessage='';
  bool _isLoading=false;
  
  static const String valideUsername="admin";
  static const String validePassword='1234';
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    
    super.dispose();
  }
  Future<void> _handleLogin()async{
    setState(() {
      _errorMessage='';
      _isLoading=true;
    });

    final username=_usernameController.text.trim();
    final password=_passwordController.text.trim();


    if(username.isEmpty || password.isEmpty){
      setState(() {
        _errorMessage="Username and password cannot be empty";
        _isLoading=false;
      });

      return;


    }
    if(username==valideUsername && password==validePassword){
      final perfs=await SharedPreferences.getInstance();
      await perfs.setBool('isLoggedIn', true);
      await perfs.setString('username', username);

      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const NotesHomeScreen()));
      }
    }
    else{
      setState(() {
        _errorMessage="Invalid username or password";
        _isLoading=false;
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body:SafeArea(child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
            Icon(Icons.note_alt_outlined,
            size: 80,
            color: Colors.blue[700],),
             const SizedBox(height: 16),
                            Text(
                  'Notes App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                  ),
                ),
              const  SizedBox(height: 48),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter username',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          style: const TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          style: const TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 16,
                          ),
                          onSubmitted: (_) =>_handleLogin() ,
                        ),
                        const SizedBox(height: 16),
                        if(_errorMessage.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),border: Border.all(color: Colors.red[300]!)
                          ),
                          child: Row(children: [
                            Icon(Icons.error_outline,color: Colors.red[700],size: 20,
                            
                            ),const SizedBox(width: 8),
                            Text(_errorMessage,style: TextStyle(color: Colors.red[700],fontSize: 18,
                            fontFamily: 'Roboto'),)
                          ],),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading?null:_handleLogin,
                          style: ElevatedButton.styleFrom(elevation: 6),
                           child: _isLoading? const SizedBox(height: 20,
                           width: 20,child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),)
                        :const Text('login',
                        style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),))
              
                        


                  ],
                ),),
                

              )


          ],),),
        ),
      )
      
      
      ),);
    
  }
}
