import 'package:flate/flate.dart';
import 'package:mocktail/mocktail.dart';

class MockFlateContext extends Mock implements FlateElementMixin, FlateContext {
}

class MockFlateService extends Mock implements FlateElementMixin, FlateService {
}

class MockFlatePart extends Mock implements FlateElementMixin, FlatePart {}

class MockFlateFragment extends Mock
    implements FlateElementMixin, FlateFragment {}
