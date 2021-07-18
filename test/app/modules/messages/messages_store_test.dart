import 'package:flutter_test/flutter_test.dart';
import 'package:photogram/app/modules/messages/messages_store.dart';
 
void main() {
  late MessagesStore store;

  setUpAll(() {
    store = MessagesStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}