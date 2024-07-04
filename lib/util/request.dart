import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:developer';

import '../env/env.dart';
import 'urls.dart';

final String apiKey = Env.ptvapikey;
final String devid = Env.ptvdevid;
http.Client client = http.Client();

String generateSignature(String req) {
  var hmacSha1 = Hmac(sha1, utf8.encode(apiKey));
  var signature = hmacSha1.convert(utf8.encode(req));
  return signature.toString();
}

String getUrl(String reqUrl) {
  var url = reqUrl + (reqUrl.contains('?') ? '&' : '?');
  url += 'devid=$devid';
  final signature = generateSignature(url);
  url += '&signature=$signature';
  url = "$baseUrl$url";
  log(url);
  return url;
}

Future<String> request(String reqUrl) async {
  final url = Uri.parse(getUrl(reqUrl));
  log("$url url");
  log("hi");
  final response = await client.get(url, headers: {});
  log("hii");
  if (response.statusCode != 200) {
    log("${response.statusCode} code");
  }
  log("${response.body} body");
  return response.body;
}