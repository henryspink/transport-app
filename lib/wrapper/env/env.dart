import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PTV_API_KEY', obfuscate: true)
  static final String ptvapikey = _Env.ptvapikey;
  @EnviedField(varName: 'PTV_DEVID', obfuscate: true)
  static final String ptvdevid = _Env.ptvdevid;
}