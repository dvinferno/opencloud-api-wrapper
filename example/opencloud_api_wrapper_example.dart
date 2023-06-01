import 'package:opencloud_api_wrapper/opencloud_api_wrapper.dart';

void main(List<String> arguments) async {
  const String apiKey = "hSwisUHs9EOotFlV94cFtnd7aN7Quy/0u9ZRw9q0SqC/bUzL";
  var uni = Universe(universeId: 3294070703, apiKey: apiKey);
  print(await uni.listDataStoresAsync());
}
