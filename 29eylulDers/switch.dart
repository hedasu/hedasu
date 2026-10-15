enum OlaySeviyesi={info,warning,error,critical};


String alarmKanaliniBelirle(OlaySeviyesi seviye, int tekrarSayisi){
  return switch(seviye){
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekrarSayisi >= 5 =>
    "Sms veya email (mükerrer hata)",
    
  }
}


