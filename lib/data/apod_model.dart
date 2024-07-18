class ApodModel {
  final String copyright;
  final String date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String title;
  final String url;

  ApodModel(
      {required this.copyright,
      required this.date,
      required this.explanation,
      required this.hdurl,
      required this.mediaType,
      required this.title,
      required this.url});

  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
        copyright: json["copyright"] ?? 'No CopyRight Found',
        date: json["date"] ?? '',
        explanation: json["explanation"] ?? '',
        hdurl: json["hdurl"] ?? '',
        mediaType: json["mediaType"] ?? '',
        title: json["title"] ?? '',
        url: json["url"] ?? '');
  }
}
