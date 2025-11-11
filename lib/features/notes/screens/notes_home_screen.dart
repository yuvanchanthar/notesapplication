import 'package:flutter/material.dart';
import 'package:flutter_notesapplication/features/auth/login_screen.dart';
import 'package:flutter_notesapplication/features/notes/models/note.dart';
import 'package:flutter_notesapplication/features/notes/widgets/note_card.dart';

import 'package:flutter_notesapplication/services/local_storage.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  List<Note> _notes=[];
  bool _isLoading=true;
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

 
  

  

  Future<void>_loadNotes()async{
    setState(() => _isLoading=true);
    final loadedNotes=await LocalStorage.loadNotes();
    if(loadedNotes.isEmpty){
      loadedNotes.addAll([
      Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'welcome to notes app',
        content: 'this is your first note. you can add,view, and manage your notes here',
        createdAt: DateTime.now()),
      Note(
        id: (DateTime.now().millisecondsSinceEpoch +1).toString(),
        title: 'shopping List',
        content: 'milk,eggs,bread, butter,jam',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),),
      ]);
      await LocalStorage.saveNotes(loadedNotes);

    }
    setState(() {
      _notes=loadedNotes;
      _isLoading=false;
    });
  }
  Future<void> addNote()async{

    final  titleController=TextEditingController();
    final  contentController=TextEditingController();
    final result= await showDialog<bool>(
      context: context, 
      builder: (context)=> AlertDialog(
        title: Text("Add a new Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),hintMaxLines: 4,
                
              ),
            ),],
            ),
            actions: [
              TextButton(
                onPressed: ()=>Navigator.pop(context,false),
                 child: const Text("cancel")
                 ),
                 ElevatedButton(onPressed: (){
                if(titleController.text.trim().isNotEmpty){
                  Navigator.pop(context,true);
                }
              }, child: const Text("Add"))
            ],));
            if(result==true && titleController.text.trim().isNotEmpty){
              final newNote=Note(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
               title: titleController.text.trim(),
                content: contentController.text.trim(),
                 createdAt: DateTime.now());
                 setState(() {
                   _notes.insert(0, newNote);
                 });
                 await LocalStorage.saveNotes(_notes);

            }
        titleController.dispose();
        contentController.dispose();

  }
  Future<void> deleteNote(String id)async{
    setState(() {
      _notes.removeWhere((note)=>note.id==id);
      
    });
    await LocalStorage.saveNotes(_notes);
    
  }
  Future<void> handleLogout()async{
    final confirm= await showDialog<bool>(context: context, builder: (context)=>AlertDialog(
      title: Text("title"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context,false),
         child: const Text('cancel')),
        ElevatedButton(onPressed: ()=> Navigator.pop(context,true),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
        foregroundColor: Colors.white),
         child: const Text("logout"))
      ],
    ));
    if(confirm==true){
      await LocalStorage.logout();
      if(mounted){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginScreen()), (route)=>false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      appBar: AppBar(
        title: const Text('My Notes'),centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: 
          handleLogout, icon: Icon(Icons.logout),tooltip: 'Sign out',)
        ],
      ),
      body: _isLoading? const  Center(child: CircularProgressIndicator(),):_notes.isEmpty? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add_outlined,size: 80,
            color: Colors.grey[400],),
            const SizedBox(height: 16,),
            Text('no notes yet',style: TextStyle(
              fontSize: 20,color: Colors.grey[600]
            ),),
            const SizedBox(height: 6,),
            Text("Tap the + button to add a note",style: TextStyle(fontSize: 14,color: Colors.grey[500]),),


            

          ],
        ),
      )
      :ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _notes.length,
        itemBuilder: (context, index){

          return NoteCard(
            note: _notes[index], onDelete:() =>deleteNote(_notes[index].id));
        },
    ), 
    floatingActionButton: FloatingActionButton(
    onPressed: addNote,
    tooltip: 'Add note',
    child: Icon(Icons.add),));
  }
}