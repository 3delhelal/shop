import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String dateFromating(Timestamp x) {
  var nextday = x.toDate().add(const Duration(days: 1));
  var today = x.toDate();
  if (Timestamp.now().toDate().day +
          Timestamp.now().toDate().month +
          Timestamp.now().toDate().year ==
      today.day + today.month + today.year) {
    return DateFormat('hh:mm a').format(x.toDate());
  } else if (Timestamp.now().toDate().day +
          Timestamp.now().toDate().month +
          Timestamp.now().toDate().year ==
      nextday.day + nextday.month + nextday.year) {
    return "yesterday";
  }

  return DateFormat("dd/MM/yyyy").format(x.toDate());
}
