import 'package:http/http.dart' as http;

Future getdata() async {
  String url = 'https://jsonplaceholder.typicode.com/posts';
  final response = await http.get(Uri.parse(url));
  print(response.body);
}
