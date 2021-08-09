import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youtube_api/model/Video.dart';

const key_youtube_api = "";
const channel_id = "UCVHFbqXqoYvEWM1Ddxl0QDg";
const url = "https://www.googleapis.com/youtube/v3/";

class Api {
  Future<List<Video>> pesquisar (String pesquisa) async {
    http.Response response = await http.get(
        Uri.parse(url + "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$key_youtube_api"
            "&channelId=$channel_id"
            "&q=$pesquisa")
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);
      List<Video> videos =  dadosJson["items"].map<Video>(
          (map) {
            return Video.fromJson(map);
          }
      ).toList();
      return videos;
    }
    throw '';
  }
}