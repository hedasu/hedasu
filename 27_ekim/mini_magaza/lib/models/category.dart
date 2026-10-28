enum Category {
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('Aksesuar', 'AK');

  final String baslik;
  final String ikon;

  const Category(this.baslik, this.ikon);
}
