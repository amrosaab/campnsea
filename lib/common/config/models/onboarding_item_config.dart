class OnBoardingItemConfig {
  final String title;
  final String desc;
  final String image;

  OnBoardingItemConfig({
    this.title = '',
    this.desc = '',
    this.image = '',
  });

  factory OnBoardingItemConfig.fromJson(Map json) {
    return OnBoardingItemConfig(
      title: '${json['title']}',
      desc: '${json['desc']}',
      image: '${json['image']}',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['image'] = image;

    return data;
  }

  OnBoardingItemConfig copyWith({
    String? title,
    String? desc,
    String? image,
  }) {
    return OnBoardingItemConfig(
      desc: desc ?? this.desc,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }
}
