class AdsMenuType {
  const AdsMenuType({
    required this.title,
    required this.name,
    required this.count,
    this.onTap,
  });

  final String title;
  final String name;
  final int count;
  final Function? onTap;
}
