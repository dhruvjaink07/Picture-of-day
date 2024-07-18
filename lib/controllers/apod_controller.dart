import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:picture_of_day/data/apod_model.dart';

class APODController {
  final String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';

  Future<List<ApodModel>> getApodData(int count) async {
    Uri url = Uri.parse("https://api.nasa.gov/planetary/apod?api_key=$apiKey&count=$count");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body); 
      List<ApodModel> apodList = jsonData.map((data) => ApodModel.fromJson(data)).toList();
      print(apodList[0].url);
      return apodList;
    } else {
      throw Exception('Failed to load APOD data');
    }
  }
}
