import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var chave = Uri.parse(
  'https://api.hgbrasil.com/finance?format=json-cors&key=fbfe6e34',
);

Future<Map<String, dynamic>> getData() async {
  try {
    print('🔍 Fazendo requisição para a API...');
    http.Response resposta = await http.get(chave);
    print('✅ Resposta recebida - Status: ${resposta.statusCode}');

    if (resposta.statusCode == 200) {
      var data = json.decode(resposta.body);
      print('📊 Dados recebidos: $data');
      return json.decode(resposta.body);
    } else {
      throw Exception('Failed to load data ${resposta.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
  // return json.decode(resposta.body);
}
