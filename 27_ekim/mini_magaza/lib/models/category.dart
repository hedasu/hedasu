enum Category{
  hepsi,
  elektronik,
  taki,
  erkekGiyim,
  kadinGiyim;
}

extension CategoryExtension on Category {
  String get gorunenAd{
    switch (this) {
      case Category.hepsi:
        return "Tümü";
      case Category.elektronik:
        return "Elektronik";
      case Category.taki:
        return "Takı & Aksesuar";
      case Category.erkekGiyim:
        return "Erkek Giyim";
      case Category.kadinGiyim:
        return "Kadın Giyim";
    }
  }
  static Category apiMetindenUret(String apiMetni){
    switch(apiMetni.toLowerCase().trim()){
      case'electronics':
        return Category.elektronik;
      case'jewelery':
        return Category.taki;
      case"men's-clothing":
        return Category.taki;
      case"women's-clothing":
        return Category.kadinGiyim; 
      default:
        return Category.elektronik;
    }
  }
}