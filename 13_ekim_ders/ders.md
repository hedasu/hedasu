1. Widget tree
*iskelet
*immutable(değişmez)
*Çok ucuz (hafif)
*saniyede 60-120 kez çöpe atılıp yeniden üretilir
*ekranda çizim yapmaz
*sadece şablon sunar




2. Element Tree
*Yönetici & Yaşayan Omurga
*Mutable (durumu ve referansı hafızada canlı tutar değişir)
*widget ile renderobject arasındaki koordinatördür(organşizasyonu sunar)




// canUpdate

static bool canUpdate(Widget oldWidget,Widget newWidget){
    return oldWidget.runtimeType=newWidget.runtimeType &&oldWidget.key==newWidget.key;
}

// react native e kıyasla çok düşük ram tüketimi



State Yaşam döngüsü

*StatefulWidget immutable (olarak değişmez) her rebuildde yeniden oluşturulur


*State mutable (durumu saklar) rebuild sırasında çöpe atılmaz. element tarafında devam eder

Eğer iki sınıf birleşik olsaydı her rebuild esnasında kullanıcı girdiler yayaçlar controllerlar vb. sıfırlanırdı
