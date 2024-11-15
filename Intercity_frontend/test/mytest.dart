import 'package:login_app/file_to_test.dart';
import 'package:test/test.dart';

void main() {
  test('Some string', () {
    final counter = Counter();
    counter.increment();
    expect(counter.value, 1);
  });
}
