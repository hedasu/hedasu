mixin Yuzme {
  void dalisYap() {
    print("Su altına daldı");
  }
}

class Denizci with Yuzme {
  final String ad;

  Denizci({required this.ad});
}

void main() {
  final denizci = Denizci(
    ad: "Denizci",
  );

  denizci.dalisYap();
}