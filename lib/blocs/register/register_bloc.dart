import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:date_format/date_format.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:new_ucon/models/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<LoginUser>((event, emit) async {
      if(event.server==1){
        UserData? userData=await getUserData(event.phoneNumber);
        if(userData==null){
          await registerUser(event.phoneNumber);
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("server", event.server);
      await prefs.setString("phoneNumber", event.phoneNumber);
      emit(LoginUserSuccess());

    });
  }

  Future<UserData?> getUserData(String phoneNumber)async{
   final response= await http.get(Uri.parse("https://ucontv.com.kg/abon/?command=get_balance&phone_number=$phoneNumber}"));
   if(response.body.contains("not found")){
     return null;
   }else{
     return userDataFromJson(response.body)[0];
   }

  }
  Future<void> registerUser(String phoneNumber) async{
    await http.get(Uri.parse("https://ucontv.com.kg/abon/?command=create&phone_number=$phoneNumber&sum=400&payed_month=99"));
  }
}
