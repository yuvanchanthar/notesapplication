import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteController=TextEditingController();
  List<Notes> notes=[];
   void addNote(){
    final text=_noteController.text.trim();
    if(text.isEmpty)
      return;
       setState(() {
      notes.add(Notes(title: text, timestamp: DateTime.now().toString()));
    });
      
    
    _noteController.clear();
   
   

   }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: ListView(children: [DrawerHeader(child: Center(child: Text("username"))),ListTile(leading: Icon(Icons.logout),title: Text("Log Out"),onTap: () => dispose())],),),
        
    
        
      
      appBar: AppBar(title: Text("Homepage"),centerTitle: true,
      

      ),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)) ,
                  hintText: "write an notes"),),
                  SizedBox(height: 50,),
                  ElevatedButton(onPressed: addNote, child: Text("add notes")),
                  const SizedBox(height: 16,),
                  
                  Expanded(
                    child:notes.isEmpty? Center(
                      child: Text("No notes yet..."),
                    )
                    : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context,index){
                        final note=notes[index];
                        return
                        Card(
                          child: ListTile(
                            title: Text(note.title),subtitle: Text("created:${note.timestamp}"),
                          ),
                        );}
                      ),
                  )
                  
          ],
        )),
    );
  }
}
class Notes{
  String title;
  String timestamp;

  Notes({required this.title,required this.timestamp});
}