import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:states_push/firebase_notifications.dart';
import 'package:states_push/model/payment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:states_push/payment_controller_mobx.dart';
import 'package:states_push/payment_controller_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt getIt = GetIt.I;
  getIt.registerSingleton<PaymentControllerMobx>(PaymentControllerMobx());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListAccountsPage()
    );
  }
}

class ListAccountsPage extends StatelessWidget {

  PaymentControllerMobx paymentController = GetIt.I.get<PaymentControllerMobx>();

  List<Payment> payments = [];

  @override
  Widget build(BuildContext context) {
    FirebaseNotifications(context).setUpFirebase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contas a pagar"),
      ),
      body: Observer(
        builder: (_) {
          return paymentController.payments.isEmpty ? Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Nenhuma conta recebida neste momento...",
                style: TextStyle(
                    fontSize: 25
                ),
              )
          ) : DataTable(
          columns: <DataColumn>[
            getColumn('Tipo'),
            getColumn('Local'),
            getColumn('Valor'),
          ],
          rows: getRows(paymentController),
          );
        },
      ),
    );
  }

  List<DataRow> getRows(PaymentControllerMobx controller){
    List<DataRow> rows = [];

    for(var index = 0; index < controller.payments.length; index++) {
      rows.add(
        DataRow(
            selected: controller.payments[index].selected,
            cells: <DataCell>[
              DataCell(Text(controller.payments[index].type)),
              DataCell(Text(controller.payments[index].place)),
              DataCell(Text("${controller.payments[index].value}")),
            ],
            onSelectChanged: (value) {
              controller.payments[index].selected = value ?? false;
              controller.update(index, controller.payments[index]);
            },
        )
      );
    }

    return rows;
  }

  DataColumn getColumn(String label) => DataColumn(
    label: Text(
      label,
      style: const TextStyle(fontStyle: FontStyle.italic),
    ),
  );

}
