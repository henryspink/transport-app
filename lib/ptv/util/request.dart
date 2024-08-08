import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import '../env/env.dart';
import 'urls.dart' as urls;

final String apiKey = Env.ptvapikey;
final String devid = Env.ptvdevid;
http.Client client = http.Client();

/// Generate a signature for a request
/// 
/// Takes in a request url including the base url and authentication
/// 
/// Returns the signature for the request
String generateSignature(String req) {
  var hmacSha1 = Hmac(sha1, utf8.encode(apiKey));
  var signature = hmacSha1.convert(utf8.encode(req));
  return signature.toString();
}

/// Construct the full URL for a request
/// adds the base url, authentication, and signature
/// 
/// Takes in a request endpoint in the form of `/version/endpoints?params`
/// Returns a url in the form of `https://timetableapi.ptv.vic.gov.au/version/endpoints?params&devid=devid&signature=signature`
/// 
/// Example:
/// ```dart
/// getFullUrl("/v3/disruptions") => "https://timetableapi.ptv.vic.gov.au/v3/disruptions?devid=devid&signature=signature"
/// getFullUrl("/v3/disruptions?disruption_status=current") => "https://timetableapi.ptv.vic.gov.au/v3/disruptions?disruption_status=current&devid=devid&signature=signature"
/// ```
String getFullUrl(String reqUrl) {
  var url = reqUrl + (reqUrl.contains('?') ? '&' : '?');
  url += 'devid=$devid';
  final signature = generateSignature(url);
  url += '&signature=$signature';
  url = "${urls.baseUrl}$url";
  log(url);
  return url;
}

/// Request data from the PTV API
/// 
/// Takes in the request URL in the form of `/version/endpoints?params`, or a `urls` object. 
/// 
/// The base url and authentication are added automatically
/// 
/// Returns the response body decoded into a Map
/// 
/// Example:
/// ```dart
/// request("/v3/disruptions") => resulting json response as a Map
/// request(urls.Disruptions.all); => resulting json response as a Map
/// ```
Future<Map> request(String reqUrl, String? params) async {
  String fullUrl;
  if (params == "" || params == null) {
    fullUrl = getFullUrl(reqUrl);
  } else {
    fullUrl = getFullUrl("$reqUrl?$params");
  }
  log(fullUrl);
  final uri = Uri.parse(fullUrl);
  http.Response response;
  try {
    response = await client.get(uri, headers: {});
  } catch (e) {
    log(e.toString());
    return <String, String>{
      "error": e.toString(),
      "message": "Failed to connect to the server"
    };
  }
  if (response.statusCode != 200) {
    log("${response.statusCode} code");
    return <String, dynamic>{
      "error": response.statusCode,
      "message": response.body
    };
  }
  log(response.body);
  return jsonDecode(response.body);
}
