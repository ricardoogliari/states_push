import 'package:mobx/mobx.dart';
import 'package:states_push/model/payment.dart';

part 'payment_controller_mobx.g.dart';

class PaymentControllerMobx = PaymentControllerBase with _$PaymentControllerMobx;

abstract class PaymentControllerBase with Store {
  @observable
  var payments = ObservableList();

  @action
  void add(Payment payment) {
    payments.add(payment);
  }

  @action
  void update(int index, Payment payment){
    payments.removeAt(index);
    payments.insert(index, payment);
  }
}
