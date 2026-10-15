//soyutlama abstraction kavramı

/*

// 1. adım Contract (Sözleşmeler)


abstract class AutReposity{
  Future<String>login(String email,String password);
  Future<void>logout();
  bool get isAuth;
}

class FirebaseAuthRepository implements AutReposity{
    @override 
    Future<String> login(String email, String password) async{
         //gerçek Firebase SDK Çağrısı
        return "firebase_token_xyz_123";
    }

    @override 
    Future<void> logout async {
        //Firebase logout
    }

    @override
    bool get isAuth => true;
}

// test ve offline simülasyon 

class MockAuthReposity implements AutReposity{
    @override
    Future<String> login(String email,String password) async{
        await Future.delayed(Duration(second:1));
        return "mock_token_abc_789";
    }

    @override 
    Future<void> logout() async{}

    @override
    bool get isAuth => false;
}

*/

/*
mixin Logger {
    void log(String msg)=>print("LOG:$msg");
}

mixin Analytics{
    void log(String msg)=>print("Analiz: $msg");
}

class PaymentService with Logger,Analytics{
    void pay(){
        log("Ödeme Yapıldı");
    }
}


abstract class BaseWidget{

}

// sadec BaseWidgetve alt sınıflarda kullanılabilir

mixin LifeLogger with BaseWidget{
    void logInit() => print("Widget Başlatıldı");
}

*/

/*
extension StringValidator on String{
    bool get isValidEmail{
        final emailRegex=RegExp(jfırkjedgkr);
        return emailRegex.hasMatch(this);
    }

    String toCapitalize(){
        if(isEmpty) return this;
        return this[0].toUpperCase() + substring(1);
    }
}


// Kullanımı 
void main(){
    String email="selahaddin@advance.com";
    if(email.isValidEmail){
        print("Geçerli Eposta");

    }else{
        print("Geçersiz Eposta");
    }
}

*/

/*

abstract class Identifiable {
  String get id;
}


// T tipi Mutlaqka Identifiable arayüzünü uygulamak ZORUNDA
class GenericCache <T extends Identifiable> {
  final Map<String, T> _storage = {};


  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id];
}. */

import 'dart:async';

void main() async {
  print("1. Senkron başladı");
  scheduleMicrotask(() {
    print("2. Task oluştu(Vip kuyruk)");
  });
  Future(() {
    print("3. Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4. Future.microtask çalıştı");
  });

  print("5. Senkron kod tamamlandı");
}
