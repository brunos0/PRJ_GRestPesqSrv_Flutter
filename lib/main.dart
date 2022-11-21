import 'dart:ui';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:flutter/Material.dart';
//import 'dart:developer';
import 'GPesq.dart';
import 'dart:convert';

void main() => runApp(GRestPesq());

RestSrv() async {
  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  //log('Servidor rodando em http://${server.address.host}:${server.port}');
}

Future<Response> _echoRequest(Request request) async {
  String keyPesq = request.url.toString().substring(5);
  Map<String, String> Result = Map();
  //log(keyPesq);

  Result = await GPesq(keyPesq);

  return Response.ok(json.encode(Result));
}

class GRestPesq extends StatelessWidget {
  @override
  GRestPesq({super.key});

  @override
  build(BuildContext context) {
    RestSrv();
    return MaterialApp(
        title: 'GPesq Rest Server',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('GPesq Rest Server'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Servidor iniciado em localhost na porta 8080\n\n",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "Minimize o aplicativo para mantê-lo \n rodando em segundo plano.\n\n",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Atenção!\nEncerrar o aplicativo causará a \n interrupção do serviço.",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}
