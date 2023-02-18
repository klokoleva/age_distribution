import 'dart:convert';

import 'package:agedistribution/agemodel.dart';
import 'package:http/http.dart' as http;

services(String name, String countryId) async {
  final Map<String, String> queryParameters = <String, String>{
    'name': name,
    'country_id': countryId,
  };
  var url = Uri.https('api.agify.io', '/', queryParameters);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return AgeModel.fromJson(data);
  } else {
    throw 'Request failed with status: ${response.statusCode}.';
  }
}
