/// A single explainable observation produced by Atlas Doctor.
class DoctorObservation {
  const DoctorObservation({
    required this.title,
    required this.evidence,
    required this.recommendation,
  });

  final String title;
  final String evidence;
  final String recommendation;
}
