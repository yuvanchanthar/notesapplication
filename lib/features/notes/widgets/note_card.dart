import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {

  final Note note;
  final VoidCallback  onDelete;
  const NoteCard({super.key,
  required this.note,
  required this.onDelete});

  String _formatDate(DateTime date){
    final now=DateTime.now();
    final difference=now.difference(date);

    if(difference.inDays==0){
      if(difference.inHours==0){
        if(difference.inMinutes==0){
          return "justnow";
        }
        return'${difference.inMinutes}m ago';

      }
      return'${difference.inHours}h ago';
    }
    else if(difference.inDays==1){
      return 'yesterday';
    }
    else if(difference.inDays<7){
      return '${difference.inDays}d ago';
    }
    else{
      final months=['Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
      return '${months[date.month-1]} ${date.day},${date.year}';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Card( 
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(note.title,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            Text(note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text(_formatDate(note.createdAt),style: TextStyle(fontSize: 12,color: Colors.grey[600]),),

          ],
        ),
        trailing: IconButton(
           icon: const Icon(
          Icons.delete_outline,
          color: Colors.red,),
          onPressed: (){
          showDialog(context: context, builder: (context)=>AlertDialog(

            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(context), child: Text('cancel')),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
                onDelete();
              },style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white),
                 child: Text('Delete'),),
            ],
        
          ));
        },
          

        ),
        onTap: () {
          showDialog(
            context: context,
             builder: (context)=> AlertDialog(
              title: Text(note.title),
              content: SingleChildScrollView(
                child: Text(note.content),

              ),
              actions: [
                TextButton(onPressed: ()=> Navigator.pop(context), child: Text("close"))
              ],
             ));
        },
      ),
    );
  }
}