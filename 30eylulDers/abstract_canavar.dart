abstract class Canavar {
  final String ad;

  Canavar({required this.ad});

  void kukre();
}

class ayi extends Canavar {
  ayi({required super.ad});

  @override
  void kukre() {
    print("roar");
  }
}

class ejderha extends Canavar {
  ejderha({required super.ad});

  @override
  void kukre() {
    print("ragh");
  }
}

void main() {
  print("Canavar türleri ve sesleri");

  final List<Canavar> canavarTurleri = [
    ayi(ad: "Kastamonu Ayısı"),
    ejderha(ad: "Shrekteki ejderha"),
  ];

  for (var canavar in canavarTurleri) {
    print(canavar.ad);
    canavar.kukre();
  }
}