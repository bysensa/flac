import 'package:telemetry/telemetry.dart';
import 'package:test/test.dart';

void main() {
  test('should return correct severity text', () {
    expect(LogLevel.trace.severityText, 'TRACE');
    expect(LogLevel.trace2.severityText, 'TRACE2');
    expect(LogLevel.trace3.severityText, 'TRACE3');
    expect(LogLevel.trace4.severityText, 'TRACE4');
    expect(LogLevel.debug.severityText, 'DEBUG');
    expect(LogLevel.debug2.severityText, 'DEBUG2');
    expect(LogLevel.debug3.severityText, 'DEBUG3');
    expect(LogLevel.debug4.severityText, 'DEBUG4');
    expect(LogLevel.info.severityText, 'INFO');
    expect(LogLevel.info2.severityText, 'INFO2');
    expect(LogLevel.info3.severityText, 'INFO3');
    expect(LogLevel.info4.severityText, 'INFO4');
    expect(LogLevel.warn.severityText, 'WARN');
    expect(LogLevel.warn2.severityText, 'WARN2');
    expect(LogLevel.warn3.severityText, 'WARN3');
    expect(LogLevel.warn4.severityText, 'WARN4');
    expect(LogLevel.error.severityText, 'ERROR');
    expect(LogLevel.error2.severityText, 'ERROR2');
    expect(LogLevel.error3.severityText, 'ERROR3');
    expect(LogLevel.error4.severityText, 'ERROR4');
    expect(LogLevel.fatal.severityText, 'FATAL');
    expect(LogLevel.fatal2.severityText, 'FATAL2');
    expect(LogLevel.fatal3.severityText, 'FATAL3');
    expect(LogLevel.fatal4.severityText, 'FATAL4');
  });

  test('should return correct severity number', () {
    expect(LogLevel.trace.severityNumber, 1);
    expect(LogLevel.trace2.severityNumber, 2);
    expect(LogLevel.trace3.severityNumber, 3);
    expect(LogLevel.trace4.severityNumber, 4);
    expect(LogLevel.debug.severityNumber, 5);
    expect(LogLevel.debug2.severityNumber, 6);
    expect(LogLevel.debug3.severityNumber, 7);
    expect(LogLevel.debug4.severityNumber, 8);
    expect(LogLevel.info.severityNumber, 9);
    expect(LogLevel.info2.severityNumber, 10);
    expect(LogLevel.info3.severityNumber, 11);
    expect(LogLevel.info4.severityNumber, 12);
    expect(LogLevel.warn.severityNumber, 13);
    expect(LogLevel.warn2.severityNumber, 14);
    expect(LogLevel.warn3.severityNumber, 15);
    expect(LogLevel.warn4.severityNumber, 16);
    expect(LogLevel.error.severityNumber, 17);
    expect(LogLevel.error2.severityNumber, 18);
    expect(LogLevel.error3.severityNumber, 19);
    expect(LogLevel.error4.severityNumber, 20);
    expect(LogLevel.fatal.severityNumber, 21);
    expect(LogLevel.fatal2.severityNumber, 22);
    expect(LogLevel.fatal3.severityNumber, 23);
    expect(LogLevel.fatal4.severityNumber, 24);
  });
}
