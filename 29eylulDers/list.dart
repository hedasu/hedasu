void main(){
  final List<String> aktifMikroservisler=[
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0",    
  ];
  aktifMikroservisler.add("telemetry-collector:v:1.0");
  print("Aktif servisler: (${aktifMikroservisler.length}adet): $aktifMikroservisler");


//sabitt uzunluktaki liste(fixed-lenght)
  final List<String> cekirdekYukDengeleyiciler=List.filled(4,"Port-Kapalı",growable:false);
  
  cekirdekYukDengeleyiciler[0]="LB-NODE-01; 192.168.1.10(Online)";

  cekirdekYukDengeleyiciler[1]="LB-NODE-02; 192.168.1.11(Online)";
  
  //cekirdekYukDengeleyiciler.add("") : hata sabait uzunlukluya ekleyemezsin

  print("Çekirdek Yük Dengeleyici Portları: $cekirdekYukDengeleyiciler");

  //Programatik List Üretici
  final List<String> kubernetsPodlari=List.generate(3,(index)=>"pod-node-eu-west-${index+1} [Ram: 16 gb, CPU:4 Cores]",);

  print("Oluşturulan K8s Podları : $kubernetsPodlari");

  //Değğiştirilemez list
  final List<String>guvenlikDuvariPortlari=List.unmodifiable([
      "22/TCP (SSH)",
      "443/TCP (HTTPS)",
      "6443/TCPP (K8s-API)",
  ]);

  // guvenlikDuvariPortlari[0]="80/TCP": hata
  print("Guvenlik Duvarı Korumalı Portlar: $guvenlikDuvariPortlari");


}