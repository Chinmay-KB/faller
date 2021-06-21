/// PODO for Orbit data.
class Orbit {
  final double _radius;
  final Map<String, String> _data;

  /// Constructor for [Orbit]
  Orbit({required double radius, required Map<String, String> data})
      : _radius = radius,
        _data = data;

  /// Get radius of the orbit
  double get radius => _radius;

  /// Get data payload associated with the orbit
  Map<String, String> get data => _data;
}
