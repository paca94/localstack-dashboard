import 'enums.dart';

extension SupportServiceTypeStringExtension on String {
  SupportServiceTypes get supportServiceType {
    switch (this) {
      case 'aws':
        return SupportServiceTypes.aws;
      case 'other':
        return SupportServiceTypes.other;
      case 'empty':
        return SupportServiceTypes.empty;
      default:
        return SupportServiceTypes.other;
    }
  }
}
