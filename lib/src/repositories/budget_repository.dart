import 'dart:io';
import 'dart:convert';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';


class BudgetRepository {
  final _baseUrl = 'https://api.notion.com/v1';
  final Client _client;
  final secret = dotenv.env['NOTION_API_KEY'];
  final dbId = dotenv.env['NOTION_DATABASE_ID'];

  BudgetRepository({Client? client}) : _client = client ?? Client();

  Future<List<ItemModel>> getItems() async {
    try {
      final url = '$_baseUrl/databases/$dbId/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $secret',
          'Notion-Version': '2021-05-13',
        },
      );
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((e) => ItemModel.fromMap(e))
            .toList()
              ..sort(
                (a, b) => b.date.compareTo(a.date),
              );
      } else {
        throw Failure(message: "Something went wrong ($statusCode)");
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong 2');
    }
  }

  Future<List<DataResult>> getDatabase() async {
    try {
      final url = '$_baseUrl/databases';
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $secret',
          'Notion-Version': '2021-05-13',
        },
      );
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((e) => DataResult.fromMap(e))
            .toList();
      } else {
        throw Failure(message: "Something went wrong ($statusCode)");
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong 2');
    }
  }

  Future<dynamic> addItems(Map<String, dynamic> data) async {
    try {
      final url = '$_baseUrl/pages/';

      var body = {
        "parent": {"database_id": dbId},
        "properties": {
          "Name": {
            "title": [
              {
                "text": {"content": data['name']}
              }
            ]
          },
          "Category": {
            "select": {"name": data['category']}
          },
          "Date": {
            "date": {"start": data['date']}
          },
          "Price": {"number": double.parse(data['price'])}
        }
      };
      final response = await _client.post(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $secret',
            HttpHeaders.contentTypeHeader: 'application/json',
            'Notion-Version': '2021-05-13',
          },
          body: json.encode(body));
      return response;
    } catch (_) {
      throw const Failure(message: 'Something went wrong 2');
    }
  }

  Future<dynamic> deletePage(String pageId) async {
    try {
      final url = '$_baseUrl/pages/$pageId';

      final response = await _client.patch(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $secret',
            HttpHeaders.contentTypeHeader: 'application/json',
            'Notion-Version': '2021-05-13',
          },
          body: json.encode({"archived": true}));
      return response;
    } catch (_) {
      throw const Failure(message: 'Something went wrong 2');
    }
  }

  void dispose() {
    _client.close();
  }
}
