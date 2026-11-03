
/*
1. WIDGET TREE (Widget Ağacı)

* İSKELET / ŞABLON
  Uygulamanın arayüzünün nasıl görünmesi gerektiğini tanımlar.
  Örneğin: Text, Row, Column, Container, ElevatedButton.

* IMMUTABLE (Değişmez)
  Widget oluşturulduktan sonra kendi özellikleri değiştirilemez.
  Yeni bir görünüm gerektiğinde yeni Widget nesneleri oluşturulabilir.

* ÇOK UCUZ (HAFİF)
  Widget nesneleri genellikle hafiftir.
  Çünkü doğrudan çizim yapmazlar; arayüzü tanımlarlar.

* Saniyede 60-120 kez yeniden oluşturulabilir.
  NOT: Bu her widget'ın sürekli yeniden oluşturulduğu anlamına gelmez.
  Animasyon gibi durumlarda build() saniyede 60 veya 120 kez
  çalışabilir (cihazın yenileme hızına ve uygulamaya bağlıdır).

* EKRANDA ÇİZİM YAPMAZ.
  Widget Tree doğrudan piksel çizmez.
  Çizim işlemleri RenderObject ve Flutter Engine aracılığıyla yapılır.

* SADECE ŞABLON SUNAR.
  Flutter'a "Ekranda ne bulunmalı?" sorusunun cevabını verir.
*/


/*
2. ELEMENT TREE (Element Ağacı)

* YÖNETİCİ & YAŞAYAN OMURGA
  Widget Tree ile RenderObject Tree arasındaki bağlantıyı yönetir.

* MUTABLE (Değişebilir)
  Widget'ların aksine Element nesneleri güncellenebilir.
  Uygun koşullarda rebuild sırasında korunurlar.

* Widget ile RenderObject arasındaki KOORDİNATÖRDÜR.
  Widget'ın tanımladığı arayüzü gerçek çalışma yapısıyla eşleştirir.

* Element, ilgili Widget'a referans tutar.
  Yeni bir Widget geldiğinde eski referansını güncelleyebilir.

* StatefulWidget için State nesnesinin yaşamını yönetir.
  Böylece her rebuild sırasında State nesnesinin
  yeniden oluşturulması gerekmez.

ÖNEMLİ:
Widget = Ne gösterilecek?
Element = Hangi Widget korunacak / güncellenecek?
RenderObject = Yerleşim ve çizim nasıl yapılacak?
*/


/*
3. canUpdate() METODU

Flutter, eski Widget ile yeni Widget'ın
aynı Element üzerinden devam edip edemeyeceğine karar verir.

Bunun için Widget.canUpdate() kontrolünü kullanır.
*/

static bool canUpdate(Widget oldWidget, Widget newWidget) {
  return oldWidget.runtimeType == newWidget.runtimeType &&
         oldWidget.key == newWidget.key;
}

/*
SATIR SATIR AÇIKLAMA:

static
  Metot Widget sınıfına aittir.
  Çağırmak için Widget nesnesi oluşturmamız gerekmez.

bool
  Metot true veya false döndürür.

oldWidget
  Daha önce Element tarafından kullanılan Widget.

newWidget
  Yeni build sonucunda gelen Widget.

runtimeType
  Widget'ın çalışma zamanındaki türüdür.
  Örneğin: Text, Container, UrunKarti.

oldWidget.runtimeType == newWidget.runtimeType
  Eski ve yeni Widget aynı türde mi diye kontrol eder.

oldWidget.key == newWidget.key
  Eski ve yeni Widget'ın key değerleri aynı mı diye kontrol eder.
  İkisi de null ise bu karşılaştırma true olur.

&&
  VE operatörüdür.
  İki koşulun da true olması gerekir.

return
  Kontrolün sonucunu geri döndürür.


SONUÇ:

TRUE:
  Widget türü ve key eşleşiyorsa mevcut Element
  güncellenerek kullanılabilir.

  StatefulWidget ise mevcut State nesnesi de korunabilir.

FALSE:
  Eski Element bu yeni Widget için yeniden kullanılamaz.
  Yeni Widget için uygun yeni bir Element oluşturulur.

  Eski StatefulElement kaldırılıp dispose edilirse
  ona bağlı State nesnesi de yaşamını tamamlar.

ÖNEMLİ:
canUpdate() yalnızca Widget türünü ve key değerini kontrol eder.
Widget'ın bütün özelliklerinin aynı olup olmadığına bakmaz.
*/


/*
4. REACT NATIVE İLE RAM KARŞILAŞTIRMASI

Flutter'da hafif Widget nesnelerinin yeniden oluşturulması
genellikle düşük maliyetlidir.

Element ve RenderObject yapılarının uygun durumlarda
korunması da gereksiz nesne oluşturmalarını azaltır.

ANCAK:
"Flutter, React Native'den her zaman daha az RAM kullanır"
demek teknik olarak doğru değildir.

RAM tüketimi;
uygulamanın büyüklüğüne, görsellere, kullanılan paketlere,
cihaza ve uygulamanın mimarisine bağlı olarak değişir.

Widget'ın hafif olması, uygulamanın tamamının
mutlaka daha az RAM kullanacağı anlamına gelmez.
*/


/*
5. STATE YAŞAM DÖNGÜSÜ

* StatefulWidget IMMUTABLE (Değişmez)
  StatefulWidget'ın kendisi değişmez bir yapılandırmadır.

  Yeni yapılandırma gerektiğinde yeni StatefulWidget
  nesnesi oluşturulabilir.

  ANCAK her rebuild, mutlaka yeni StatefulWidget
  nesnesi oluşturur demek değildir.

* State MUTABLE (Değişebilir)
  Değişen verileri saklayabilir.

  Örneğin:
  - Sayaç değeri
  - Favori durumu
  - Kullanıcının seçtiği seçenek
  - TextEditingController referansı

* State, her rebuild sırasında çöpe atılmaz.

  State nesnesi StatefulElement ile ilişkilidir.

  Widget güncellense bile Element korunuyorsa
  mevcut State nesnesi kullanılmaya devam edebilir.

* setState() çağrıldığında:
  1. State içerisindeki veri değiştirilir.
  2. Flutter ilgili Element'ı yeniden build için işaretler.
  3. build() tekrar çalışır.
  4. Yeni Widget yapılandırması oluşturulabilir.
  5. State nesnesi korunur (Element yaşamaya devam ediyorsa).


NEDEN StatefulWidget VE State AYRI SINIFLAR?

Eğer Widget yapılandırması ile değişebilir durum
aynı kısa ömürlü yapıda tutulsaydı,
Widget yeniden oluşturulurken durumun korunması zorlaşırdı.

Flutter bu sorunu iki görevi ayırarak çözer:

StatefulWidget:
  Widget'ın değişmez yapılandırmasını taşır.

State:
  Değişebilir verileri ve yaşam döngüsünü yönetir.

Bu sayede uygun koşullarda rebuild sırasında:
  - Sayaç değeri korunur.
  - Kullanıcı girişleri korunabilir.
  - Controller nesneleri korunabilir.
  - Uygulamanın mevcut durumu devam edebilir.

DİKKAT:
Bu veriler her koşulda korunmaz.
State'in bağlı olduğu Element kaldırılır ve State dispose
edilirse durum kaybolabilir.

ÖZET:

Widget yeniden oluşturulabilir.
Element korunabilir.
State korunabilir.
RenderObject güncellenebilir.

REBUILD = HER ŞEYİ SIFIRDAN OLUŞTURMAK DEĞİLDİR!
*/
