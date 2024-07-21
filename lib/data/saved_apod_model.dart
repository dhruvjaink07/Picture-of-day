import 'package:hive/hive.dart';

part 'saved_apod_model.g.dart';

@HiveType(typeId: 1)
class SavedApodModel {
  @HiveField(0)
  final String copyright;
  
  @HiveField(1)
  final String date;
  
  @HiveField(2)
  final String explanation;
  
  @HiveField(3)
  final String hdurl;
  
  @HiveField(4)
  final String mediaType;
  
  @HiveField(5)
  final String title;
  
  @HiveField(6)
  final String url;
  
  SavedApodModel({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.title,
    required this.url,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SavedApodModel &&
        other.date == date &&
        other.url == url;
  }

  @override
  int get hashCode => date.hashCode ^ url.hashCode;
}
