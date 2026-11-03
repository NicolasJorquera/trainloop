/// Unidad de peso. La base guarda el valor y la unidad originales, y además
/// los gramos (entero) para sumar volumen sin errores de redondeo.
enum WeightUnit {
  kg(1000),
  lb(453.59237);

  const WeightUnit(this.gramsPerUnit);

  final double gramsPerUnit;

  /// [value] en esta unidad, convertido a gramos enteros.
  int toGrams(double value) => (value * gramsPerUnit).round();

  /// Gramos convertidos a esta unidad.
  double fromGrams(int grams) => grams / gramsPerUnit;

  /// [value] expresado en [from], convertido a esta unidad.
  double convertFrom(double value, WeightUnit from) =>
      from == this ? value : fromGrams(from.toGrams(value));

  static WeightUnit fromName(String? name) => WeightUnit.values.firstWhere(
    (v) => v.name == name,
    orElse: () => WeightUnit.kg,
  );
}
