import 'package:flutter/material.dart';
import 'package:user_auth_appwrite/note.dart';
import 'package:user_auth_appwrite/noteappservice.dart';

class NoteAppS extends StatefulWidget {
  const NoteAppS({super.key});

  @override
  State<NoteAppS> createState() => _NoteAppSState();
}

class _NoteAppSState extends State<NoteAppS> {
  late AppwriteService _appwriteService;
  late List<Note> _notes;
 final titleC=TextEditingController();
 final categoryC=TextEditingController();
 final subtitleC=TextEditingController();
 final dateC=TextEditingController();

  @override
void initState(){
  super.initState();
  _appwriteService=AppwriteService();
  _notes=[];
  _loadNotes();
}
Future<void>_loadNotes()async{
  try{
    final tasks= await _appwriteService.getNotes();
    setState(() {
      _notes=tasks.map((e)=>Note.fromDocument(e)).toList();
      
    });
  }
  catch(e){
    print("Error Loading Tasks:$e");
  }
}
Future<void> _addNote()async{
  final title=titleC.text;
  final subtitle=subtitleC.text;
  final category=categoryC.text;
  final date=dateC.text;

  if (title.isNotEmpty&&
  subtitle.isNotEmpty&&
  category.isNotEmpty&&
  date.isNotEmpty
  ){
    try{
      await _appwriteService.addNote(title, subtitle, category, date);
      titleC.clear();
      subtitleC.clear();
      categoryC.clear();
      dateC.clear();
      _loadNotes();
    }
    catch(e){
      print("Error loading tasks:$e");
    }
  }
}
Future<void>_deleteNote(String taskId)async{
  try{
    await _appwriteService.deleteNote(taskId);
    _loadNotes();
  }catch(e){
    print("Error Deleting Task:$e");
  }
}



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoteApp using Appwrite"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          SizedBox(height: 20,),
            TextFormField(
              controller: titleC,
              decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Title")),
            ),
             SizedBox(height: 20,),
            TextFormField(
              controller: subtitleC,
              decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Subtitle")),
            ),
             SizedBox(height: 20,),
            TextFormField(
              controller: categoryC,
              decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Category")),
            ),
             SizedBox(height: 20,),
            TextFormField(
              controller: dateC,
              decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Date")),
            ),
            SizedBox(height: 25,),
            ElevatedButton(onPressed: _addNote, child: Text("Add Notes")),
            SizedBox(height: 20,),
            Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
            itemCount: _notes.length,
             itemBuilder: (context,index){
              final notes=_notes[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.pink[200],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(notes.title),
                                Text(notes.subtitle),
                                Text(notes.category),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(notes.date),
                                    IconButton(onPressed: ()=> _deleteNote(notes.id), icon: Icon(Icons.delete))
                                  ],
                                )
                      ],
                    
                    ),
                  ),
                ),
              );
             }))
          ],
        ),
      ),
    );
  }
}