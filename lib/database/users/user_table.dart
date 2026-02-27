import 'package:supabase_flutter/supabase_flutter.dart';

class UserTable {
  final Supabase supabase = Supabase.instance;

  Future<void> addUserTable(
    String email,
    String fullname,
    String password,
    String date,
    String gender,
    String avatar,
  ) async {
    try {
      await supabase.client.from('users').insert({
        'email': email,
        'fullname': fullname,
        'password': password,
        'gender': gender,
        'dateofbirth': date,
        'avatar': "",
      });

      print("ПОЛЬЗОВАТЕЛЬ ДОБАВЛЕН!");
    } catch (e) {
      return;
    }
  }
}
