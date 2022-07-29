import 'package:http/http.dart' as http;

abstract class ClientService {
  Future<String> get(String path);
}

class HttpService implements ClientService {
  @override
  Future<String> get(String path) async {
    Uri url = Uri.parse(path);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
