import 'dart:convert';

import 'package:flutter_notesapplication/features/notes/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static const String _isLoggedInKey='isLoggedIn';
  static const String _noteskey='notes';
  static Future<void> init()async{
    _prefs=await SharedPreferences.getInstance();
  }

  static Future<bool> setLoggedIn(bool value)async{
    return await _prefs.setBool(_isLoggedInKey,value);
  }
  static Future<bool> isLoggedIn()async{
    return _prefs.getBool(_isLoggedInKey)?? false;
  }

  static Future<bool> logout()async{
    return await _prefs.remove(_isLoggedInKey);
  }

  static Future<bool> saveNotes(List<Note> notes)async{
    final notesJson=notes.map((note)=>note.toJson()).toList();
    final jsonString=jsonEncode(notesJson);
    return await _prefs.setString(_noteskey, jsonString);
  }

  static Future<List<Note>> loadNotes()async{
    final jsonString=_prefs.getString(_noteskey);
    if(jsonString==null || jsonString.isEmpty){
      return[];

    }
    try{
      final List<dynamic> jsonList=jsonDecode(jsonString);
      return jsonList.map((json)=>Note.fromJson(json)).toList();

    }catch(e){
      return[];
    }
  }
  static Future<bool> clearNotes()async{
    return await _prefs.remove(_noteskey);
  }
}