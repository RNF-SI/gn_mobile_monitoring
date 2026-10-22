/// Interpréteur d'expressions JavaScript pour les configurations GeoNature
/// Monitoring (`hidden`, `required`, conditions des règles `change`).
///
/// Le module web exécute ces chaînes avec `eval` : cet interpréteur reproduit
/// la sémantique JavaScript sur le sous-ensemble utilisé dans les protocoles
/// (https://github.com/PnX-SI/protocoles_suivi) :
/// - fonctions fléchées `({value, meta}) => expr`, `(value) => expr`,
///   corps `{ return expr; }` ;
/// - opérateurs `?:`, `??`, `||`, `&&`, `==`, `!=`, `===`, `!==`, `<`, `<=`,
///   `>`, `>=`, `+`, `-`, `*`, `/`, `%`, `!`, `-` unaire, `typeof` ;
/// - accès `a.b`, `a[b]`, `a?.b`, littéraux tableau/objet, fonctions
///   fléchées en argument (`list.some(x => …)`) ;
/// - égalité non stricte, conversions et valeurs « truthy » de JavaScript ;
/// - `Object.keys/values`, `Math.*`, `parseInt`, `parseFloat`, `Number`,
///   `String`, `isNaN`, `Array.isArray` et les méthodes usuelles des chaînes
///   et tableaux (`includes`, `indexOf`, `length`, `toLowerCase`…).
///
/// Il accepte aussi les expressions déjà converties au format Dart par
/// `TsToDartConverter` dans les modules installés avant 09/2026
/// (`value['x'] as bool`, `(meta['dataset'] as Map).keys.length`).
library;

import 'dart:math' as math;

/// Valeur JavaScript `undefined` (distincte de `null`).
class JsUndefined {
  const JsUndefined._();
  @override
  String toString() => 'undefined';
}

const undefined = JsUndefined._();

/// Erreur d'analyse ou d'exécution (équivalent d'une exception JS).
class JsEvalException implements Exception {
  final String message;
  JsEvalException(this.message);
  @override
  String toString() => 'JsEvalException: $message';
}

/// Objet dont les propriétés sont calculées à la lecture.
abstract class JsObject {
  dynamic getProperty(String name);
}

/// Fonction appelable depuis une expression.
typedef JsCallable = dynamic Function(List<dynamic> args);

class JsFunction {
  final JsCallable call;
  const JsFunction(this.call);
}

/// Interpréteur réutilisable : les expressions analysées sont mises en cache.
class JsExpressionInterpreter {
  static final Map<String, _Node> _cache = {};
  static const int _maxCacheSize = 500;

  /// Évalue [source] (une fonction fléchée ou une expression simple) et
  /// retourne sa valeur JavaScript brute.
  ///
  /// Pour une fonction fléchée, chaque paramètre est lié à la clé du même
  /// nom dans [context] (`({value, meta}) =>` ou `(value, meta) =>`).
  /// Lève [JsEvalException] en cas d'erreur de syntaxe ou d'exécution.
  dynamic evaluate(String source, Map<String, dynamic> context) {
    final node = _parse(source);
    final scope = _Scope(context);
    if (node is _ArrowNode) {
      for (final param in node.params) {
        scope.vars[param] =
            context.containsKey(param) ? context[param] : undefined;
      }
      return node.body.eval(scope);
    }
    return node.eval(scope);
  }

  /// Évalue [source] et retourne sa valeur de vérité JavaScript, ou `null`
  /// si l'expression ne peut pas être analysée ou lève une erreur.
  bool? evaluateTruthy(String source, Map<String, dynamic> context) {
    try {
      return isTruthy(evaluate(source, context));
    } on JsEvalException {
      return null;
    } catch (_) {
      return null;
    }
  }

  _Node _parse(String source) {
    final cached = _cache[source];
    if (cached != null) return cached;
    final node = _Parser(_tokenize(source)).parseProgram();
    if (_cache.length >= _maxCacheSize) _cache.clear();
    _cache[source] = node;
    return node;
  }
}

// ---------------------------------------------------------------------------
// Sémantique JavaScript
// ---------------------------------------------------------------------------

bool _isNullish(dynamic v) => v == null || v is JsUndefined;

bool isTruthy(dynamic v) {
  if (_isNullish(v)) return false;
  if (v is bool) return v;
  if (v is num) return v != 0 && !v.isNaN;
  if (v is String) return v.isNotEmpty;
  return true;
}

num _toNumber(dynamic v) {
  if (v is JsUndefined) return double.nan;
  if (v == null) return 0;
  if (v is bool) return v ? 1 : 0;
  if (v is num) return v;
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return 0;
    return num.tryParse(s) ?? double.nan;
  }
  if (v is List) return _toNumber(_toJsString(v));
  return double.nan;
}

String _numToString(num n) {
  if (n.isNaN) return 'NaN';
  if (n.isInfinite) return n > 0 ? 'Infinity' : '-Infinity';
  if (n == n.truncate() && n.abs() < 1e21) return n.truncate().toString();
  return n.toString();
}

String _toJsString(dynamic v) {
  if (v is JsUndefined) return 'undefined';
  if (v == null) return 'null';
  if (v is bool) return v ? 'true' : 'false';
  if (v is num) return _numToString(v);
  if (v is String) return v;
  if (v is List) {
    return v.map((e) => _isNullish(e) ? '' : _toJsString(e)).join(',');
  }
  if (v is JsFunction) return 'function';
  return '[object Object]';
}

bool _isPrimitive(dynamic v) =>
    _isNullish(v) || v is bool || v is num || v is String;

dynamic _toPrimitive(dynamic v) => _isPrimitive(v) ? v : _toJsString(v);

bool _strictEquals(dynamic a, dynamic b) {
  if (a is JsUndefined || b is JsUndefined) {
    return a is JsUndefined && b is JsUndefined;
  }
  if (a == null || b == null) return a == null && b == null;
  if (a is num && b is num) return !a.isNaN && !b.isNaN && a == b;
  if (a is String && b is String) return a == b;
  if (a is bool && b is bool) return a == b;
  if (_isPrimitive(a) || _isPrimitive(b)) return false;
  return identical(a, b);
}

bool _looseEquals(dynamic a, dynamic b) {
  if (_isNullish(a) || _isNullish(b)) return _isNullish(a) && _isNullish(b);
  if ((a is num && b is num) ||
      (a is String && b is String) ||
      (a is bool && b is bool)) {
    return _strictEquals(a, b);
  }
  if (a is bool) return _looseEquals(_toNumber(a), b);
  if (b is bool) return _looseEquals(a, _toNumber(b));
  if (a is num && b is String) return _strictEquals(a, _toNumber(b));
  if (a is String && b is num) return _strictEquals(_toNumber(a), b);
  if (!_isPrimitive(a) && !_isPrimitive(b)) return identical(a, b);
  return _looseEquals(_toPrimitive(a), _toPrimitive(b));
}

bool _compare(dynamic a, dynamic b, String op) {
  final pa = _toPrimitive(a);
  final pb = _toPrimitive(b);
  if (pa is String && pb is String) {
    final c = pa.compareTo(pb);
    return switch (op) {
      '<' => c < 0,
      '<=' => c <= 0,
      '>' => c > 0,
      _ => c >= 0,
    };
  }
  final na = _toNumber(pa);
  final nb = _toNumber(pb);
  if (na.isNaN || nb.isNaN) return false;
  return switch (op) {
    '<' => na < nb,
    '<=' => na <= nb,
    '>' => na > nb,
    _ => na >= nb,
  };
}

dynamic _add(dynamic a, dynamic b) {
  final pa = _toPrimitive(a);
  final pb = _toPrimitive(b);
  if (pa is String || pb is String) return _toJsString(pa) + _toJsString(pb);
  return _normalizeNum(_toNumber(pa) + _toNumber(pb));
}

num _normalizeNum(num n) =>
    n is double && n.isFinite && n == n.truncate() && n.abs() < 1e15
        ? n.toInt()
        : n;

String _typeOf(dynamic v) {
  if (v is JsUndefined) return 'undefined';
  if (v == null) return 'object';
  if (v is bool) return 'boolean';
  if (v is num) return 'number';
  if (v is String) return 'string';
  if (v is JsFunction) return 'function';
  return 'object';
}

/// Lecture d'une propriété, avec les clés numériques des Map Dart
/// (ex. `meta.nomenclatures[id]` indexé par int).
dynamic _getMember(dynamic obj, dynamic key) {
  if (_isNullish(obj)) {
    throw JsEvalException(
        "Cannot read properties of ${_toJsString(obj)} (reading '${_toJsString(key)}')");
  }
  final name = key is String ? key : _toJsString(key);
  if (obj is JsObject) return obj.getProperty(name);
  if (obj is Map) {
    if (obj.containsKey(name)) return obj[name];
    final asInt = int.tryParse(name);
    if (asInt != null && obj.containsKey(asInt)) return obj[asInt];
    // Compatibilité Dart (expressions converties par TsToDartConverter)
    if (name == 'keys') return obj.keys.map((k) => k.toString()).toList();
    if (name == 'values') return obj.values.toList();
    if (name == 'length') return obj.length;
    return _objectMethod(obj, name) ?? undefined;
  }
  if (obj is List) {
    if (name == 'length') return obj.length;
    final index = int.tryParse(name);
    if (index != null) {
      return index >= 0 && index < obj.length ? obj[index] : undefined;
    }
    return _listMethod(obj, name) ?? undefined;
  }
  if (obj is String) {
    if (name == 'length') return obj.length;
    final index = int.tryParse(name);
    if (index != null) {
      return index >= 0 && index < obj.length ? obj[index] : undefined;
    }
    return _stringMethod(obj, name) ?? undefined;
  }
  if (obj is num && name == 'toString') {
    return JsFunction((_) => _toJsString(obj));
  }
  return undefined;
}

JsFunction? _objectMethod(Map obj, String name) => switch (name) {
      'hasOwnProperty' => JsFunction((a) => obj.containsKey(_arg(a, 0)) ||
          obj.containsKey(int.tryParse(_toJsString(_arg(a, 0))))),
      _ => null,
    };

dynamic _arg(List<dynamic> args, int i) => i < args.length ? args[i] : undefined;

dynamic _callFn(dynamic fn, List<dynamic> args) {
  if (fn is! JsFunction) {
    throw JsEvalException('${_toJsString(fn)} is not a function');
  }
  return fn.call(args);
}

int _indexOf(List list, dynamic value) {
  for (var i = 0; i < list.length; i++) {
    if (_strictEquals(list[i], value)) return i;
  }
  return -1;
}

JsFunction? _listMethod(List list, String name) => switch (name) {
      'includes' => JsFunction((a) {
          final v = _arg(a, 0);
          return list.any((e) =>
              _strictEquals(e, v) ||
              (e is num && v is num && e.isNaN && v.isNaN));
        }),
      'indexOf' => JsFunction((a) => _indexOf(list, _arg(a, 0))),
      'join' => JsFunction((a) => list
          .map((e) => _isNullish(e) ? '' : _toJsString(e))
          .join(_isNullish(_arg(a, 0)) ? ',' : _toJsString(_arg(a, 0)))),
      'some' => JsFunction((a) => list
          .asMap()
          .entries
          .any((e) => isTruthy(_callFn(a.first, [e.value, e.key])))),
      'every' => JsFunction((a) => list
          .asMap()
          .entries
          .every((e) => isTruthy(_callFn(a.first, [e.value, e.key])))),
      'filter' => JsFunction((a) => list
          .asMap()
          .entries
          .where((e) => isTruthy(_callFn(a.first, [e.value, e.key])))
          .map((e) => e.value)
          .toList()),
      'map' => JsFunction((a) => list
          .asMap()
          .entries
          .map((e) => _callFn(a.first, [e.value, e.key]))
          .toList()),
      'find' => JsFunction((a) {
          for (var i = 0; i < list.length; i++) {
            if (isTruthy(_callFn(a.first, [list[i], i]))) return list[i];
          }
          return undefined;
        }),
      _ => null,
    };

JsFunction? _stringMethod(String s, String name) => switch (name) {
      'includes' =>
        JsFunction((a) => s.contains(_toJsString(_arg(a, 0)))),
      'indexOf' => JsFunction((a) => s.indexOf(_toJsString(_arg(a, 0)))),
      'startsWith' =>
        JsFunction((a) => s.startsWith(_toJsString(_arg(a, 0)))),
      'endsWith' => JsFunction((a) => s.endsWith(_toJsString(_arg(a, 0)))),
      'toLowerCase' => JsFunction((_) => s.toLowerCase()),
      'toUpperCase' => JsFunction((_) => s.toUpperCase()),
      'trim' => JsFunction((_) => s.trim()),
      'split' => JsFunction((a) => s.split(_toJsString(_arg(a, 0)))),
      'toString' => JsFunction((_) => s),
      _ => null,
    };

dynamic _parseInt(List<dynamic> a) {
  final s = _toJsString(_arg(a, 0)).trim();
  final radix = _isNullish(_arg(a, 1)) ? 10 : _toNumber(_arg(a, 1)).toInt();
  final match = RegExp(r'^[+-]?[0-9a-zA-Z]+').firstMatch(s);
  if (match == null) return double.nan;
  var digits = match.group(0)!;
  // Tronquer au premier caractère invalide pour la base
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final c = digits[i];
    if (i == 0 && (c == '+' || c == '-')) {
      buffer.write(c);
      continue;
    }
    if (int.tryParse(c, radix: radix) == null) break;
    buffer.write(c);
  }
  digits = buffer.toString();
  return int.tryParse(digits, radix: radix) ?? double.nan;
}

dynamic _parseFloat(List<dynamic> a) {
  final s = _toJsString(_arg(a, 0)).trim();
  final match = RegExp(r'^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?').firstMatch(s);
  return match == null ? double.nan : _normalizeNum(num.parse(match.group(0)!));
}

/// Arrondi JavaScript : NaN et ±Infinity sont renvoyés tels quels.
num _rounded(dynamic v, int Function(num) round) {
  final n = _toNumber(v);
  return n.isFinite ? round(n) : n;
}

final Map<String, dynamic> _globals = {
  'undefined': undefined,
  'NaN': double.nan,
  'Infinity': double.infinity,
  'parseInt': const JsFunction(_parseInt),
  'parseFloat': const JsFunction(_parseFloat),
  'isNaN': JsFunction((a) => _toNumber(_arg(a, 0)).isNaN),
  'Number': JsFunction(
      (a) => a.isEmpty ? 0 : _normalizeNum(_toNumber(_arg(a, 0)))),
  'String': JsFunction((a) => a.isEmpty ? '' : _toJsString(_arg(a, 0))),
  'Boolean': JsFunction((a) => isTruthy(_arg(a, 0))),
  'Object': {
    'keys': JsFunction((a) {
      final o = _arg(a, 0);
      if (o is Map) return o.keys.map((k) => k.toString()).toList();
      if (o is List) return [for (var i = 0; i < o.length; i++) '$i'];
      if (_isNullish(o)) {
        throw JsEvalException('Cannot convert undefined or null to object');
      }
      return <String>[];
    }),
    'values': JsFunction((a) {
      final o = _arg(a, 0);
      if (o is Map) return o.values.toList();
      if (o is List) return List.of(o);
      return <dynamic>[];
    }),
  },
  'Array': {
    'isArray': JsFunction((a) => _arg(a, 0) is List),
  },
  'Math': {
    'abs': JsFunction((a) => _toNumber(_arg(a, 0)).abs()),
    'round': JsFunction((a) => _rounded(_arg(a, 0), (n) => (n + 0.5).floor())),
    'floor': JsFunction((a) => _rounded(_arg(a, 0), (n) => n.floor())),
    'ceil': JsFunction((a) => _rounded(_arg(a, 0), (n) => n.ceil())),
    'max': JsFunction((a) => a.isEmpty
        ? double.negativeInfinity
        : a.map(_toNumber).reduce((x, y) => x.isNaN || y.isNaN ? double.nan : math.max(x, y))),
    'min': JsFunction((a) => a.isEmpty
        ? double.infinity
        : a.map(_toNumber).reduce((x, y) => x.isNaN || y.isNaN ? double.nan : math.min(x, y))),
  },
};

// ---------------------------------------------------------------------------
// Portée d'évaluation
// ---------------------------------------------------------------------------

class _Scope {
  final Map<String, dynamic> context;
  final Map<String, dynamic> vars = {};
  final _Scope? parent;

  _Scope(this.context, [this.parent]);

  dynamic lookup(String name) {
    for (_Scope? s = this; s != null; s = s.parent) {
      if (s.vars.containsKey(name)) return s.vars[name];
    }
    if (_globals.containsKey(name)) return _globals[name];
    // `controls.x.dirty` (règles change, objForm.controls converti)
    if (name == 'controls') return JsFormControls(context['dirtyFields']);
    if (context.containsKey(name)) return context[name];
    throw JsEvalException('$name is not defined');
  }
}

/// `objForm.controls` : chaque champ a un contrôle, `dirty` si l'utilisateur
/// l'a modifié (ensemble `dirtyFields` du contexte).
class JsFormControls implements JsObject {
  final dynamic dirtyFields;
  JsFormControls(this.dirtyFields);
  @override
  dynamic getProperty(String name) => {
        'dirty': dirtyFields is Set && (dirtyFields as Set).contains(name),
      };
}

// ---------------------------------------------------------------------------
// Arbre syntaxique
// ---------------------------------------------------------------------------

abstract class _Node {
  dynamic eval(_Scope scope);
}

class _Literal extends _Node {
  final dynamic value;
  _Literal(this.value);
  @override
  dynamic eval(_Scope scope) => value;
}

class _Identifier extends _Node {
  final String name;
  _Identifier(this.name);
  @override
  dynamic eval(_Scope scope) => scope.lookup(name);
}

class _ArrayNode extends _Node {
  final List<_Node> items;
  _ArrayNode(this.items);
  @override
  dynamic eval(_Scope scope) => [for (final i in items) i.eval(scope)];
}

class _ObjectNode extends _Node {
  final List<MapEntry<String, _Node>> entries;
  _ObjectNode(this.entries);
  @override
  dynamic eval(_Scope scope) =>
      <String, dynamic>{for (final e in entries) e.key: e.value.eval(scope)};
}

class _MemberNode extends _Node {
  final _Node object;
  final _Node property; // _Literal pour `a.b`
  final bool optional;
  _MemberNode(this.object, this.property, {this.optional = false});
  @override
  dynamic eval(_Scope scope) {
    final obj = object.eval(scope);
    if (optional && _isNullish(obj)) return undefined;
    return _getMember(obj, property.eval(scope));
  }
}

class _CallNode extends _Node {
  final _Node callee;
  final List<_Node> args;
  final bool optional;
  _CallNode(this.callee, this.args, {this.optional = false});
  @override
  dynamic eval(_Scope scope) {
    final fn = callee.eval(scope);
    if (optional && _isNullish(fn)) return undefined;
    return _callFn(fn, [for (final a in args) a.eval(scope)]);
  }
}

class _UnaryNode extends _Node {
  final String op;
  final _Node operand;
  _UnaryNode(this.op, this.operand);
  @override
  dynamic eval(_Scope scope) {
    if (op == 'typeof' && operand is _Identifier) {
      try {
        return _typeOf(operand.eval(scope));
      } on JsEvalException {
        return 'undefined';
      }
    }
    final v = operand.eval(scope);
    return switch (op) {
      '!' => !isTruthy(v),
      '-' => _normalizeNum(-_toNumber(v)),
      '+' => _normalizeNum(_toNumber(v)),
      'typeof' => _typeOf(v),
      _ => throw JsEvalException('Opérateur unaire inconnu $op'),
    };
  }
}

class _BinaryNode extends _Node {
  final String op;
  final _Node left;
  final _Node right;
  _BinaryNode(this.op, this.left, this.right);
  @override
  dynamic eval(_Scope scope) {
    switch (op) {
      case '&&':
        final l = left.eval(scope);
        return isTruthy(l) ? right.eval(scope) : l;
      case '||':
        final l = left.eval(scope);
        return isTruthy(l) ? l : right.eval(scope);
      case '??':
        final l = left.eval(scope);
        return _isNullish(l) ? right.eval(scope) : l;
    }
    final l = left.eval(scope);
    final r = right.eval(scope);
    switch (op) {
      case '==':
        return _looseEquals(l, r);
      case '!=':
        return !_looseEquals(l, r);
      case '===':
        return _strictEquals(l, r);
      case '!==':
        return !_strictEquals(l, r);
      case '<':
      case '<=':
      case '>':
      case '>=':
        return _compare(l, r, op);
      case '+':
        return _add(l, r);
      case '-':
        return _normalizeNum(_toNumber(l) - _toNumber(r));
      case '*':
        return _normalizeNum(_toNumber(l) * _toNumber(r));
      case '/':
        final d = _toNumber(r);
        final n = _toNumber(l);
        if (d == 0) {
          return n == 0 || n.isNaN
              ? double.nan
              : (n > 0 ? double.infinity : double.negativeInfinity);
        }
        return _normalizeNum(n / d);
      case '%':
        final d = _toNumber(r);
        if (d == 0) return double.nan;
        return _normalizeNum(_toNumber(l).remainder(d));
    }
    throw JsEvalException('Opérateur inconnu $op');
  }
}

class _ConditionalNode extends _Node {
  final _Node test;
  final _Node consequent;
  final _Node alternate;
  _ConditionalNode(this.test, this.consequent, this.alternate);
  @override
  dynamic eval(_Scope scope) => isTruthy(test.eval(scope))
      ? consequent.eval(scope)
      : alternate.eval(scope);
}

class _ArrowNode extends _Node {
  final List<String> params;
  final _Node body;
  _ArrowNode(this.params, this.body);

  /// Une fonction fléchée utilisée comme valeur (ex. `list.some(x => …)`).
  @override
  dynamic eval(_Scope scope) => JsFunction((args) {
        final inner = _Scope(scope.context, scope);
        for (var i = 0; i < params.length; i++) {
          inner.vars[params[i]] = i < args.length ? args[i] : undefined;
        }
        return body.eval(inner);
      });
}

// ---------------------------------------------------------------------------
// Analyse lexicale
// ---------------------------------------------------------------------------

enum _T { num, str, ident, punct, eof }

class _Token {
  final _T type;
  final dynamic value;
  _Token(this.type, this.value);
  bool isPunct(String p) => type == _T.punct && value == p;
  bool isIdent(String name) => type == _T.ident && value == name;
  @override
  String toString() => '$value';
}

const _puncts = [
  '===', '!==', '...', '=>', '==', '!=', '<=', '>=', '&&', '||', '??', '?.',
  '(', ')', '[', ']', '{', '}', '.', ',', ':', ';', '?', '!', '<', '>', '+',
  '-', '*', '/', '%', '=',
];

List<_Token> _tokenize(String src) {
  final tokens = <_Token>[];
  var i = 0;
  bool isIdStart(String c) => RegExp(r'[A-Za-z_$]').hasMatch(c);
  bool isIdPart(String c) => RegExp(r'[A-Za-z0-9_$]').hasMatch(c);
  bool isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  while (i < src.length) {
    final c = src[i];
    if (c.trim().isEmpty) {
      i++;
      continue;
    }
    if (isDigit(c) || (c == '.' && i + 1 < src.length && isDigit(src[i + 1]))) {
      final m = RegExp(r'(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?').matchAsPrefix(src, i)!;
      tokens.add(_Token(_T.num, _normalizeNum(num.parse(m.group(0)!))));
      i = m.end;
      continue;
    }
    if (c == "'" || c == '"' || c == '`') {
      final buffer = StringBuffer();
      i++;
      while (i < src.length && src[i] != c) {
        if (src[i] == '\\' && i + 1 < src.length) {
          final n = src[i + 1];
          buffer.write(switch (n) { 'n' => '\n', 't' => '\t', _ => n });
          i += 2;
        } else {
          buffer.write(src[i++]);
        }
      }
      if (i >= src.length) throw JsEvalException('Chaîne non terminée');
      i++;
      tokens.add(_Token(_T.str, buffer.toString()));
      continue;
    }
    if (isIdStart(c)) {
      final start = i;
      while (i < src.length && isIdPart(src[i])) {
        i++;
      }
      tokens.add(_Token(_T.ident, src.substring(start, i)));
      continue;
    }
    final p = _puncts.firstWhere((p) => src.startsWith(p, i),
        orElse: () => throw JsEvalException("Caractère inattendu '$c'"));
    // `?.` suivi d'un chiffre est un ternaire (`a?.5:1`)
    if (p == '?.' && i + 2 < src.length && isDigit(src[i + 2])) {
      tokens.add(_Token(_T.punct, '?'));
      i++;
      continue;
    }
    tokens.add(_Token(_T.punct, p));
    i += p.length;
  }
  tokens.add(_Token(_T.eof, null));
  return tokens;
}

// ---------------------------------------------------------------------------
// Analyse syntaxique (descente récursive, priorités JavaScript)
// ---------------------------------------------------------------------------

class _Parser {
  final List<_Token> t;
  var pos = 0;
  _Parser(this.t);

  _Token get peek => t[pos];
  _Token next() => t[pos++];

  bool acceptPunct(String p) {
    if (peek.isPunct(p)) {
      pos++;
      return true;
    }
    return false;
  }

  void expectPunct(String p) {
    if (!acceptPunct(p)) {
      throw JsEvalException("'$p' attendu, trouvé '${peek.value}'");
    }
  }

  _Node parseProgram() {
    final node = parseExpression();
    acceptPunct(';');
    if (peek.type != _T.eof) {
      throw JsEvalException("Fin d'expression attendue, trouvé '${peek.value}'");
    }
    return node;
  }

  _Node parseExpression() => parseAssignmentLike();

  /// Fonction fléchée, sinon ternaire.
  _Node parseAssignmentLike() {
    final arrow = tryParseArrow();
    if (arrow != null) return arrow;
    return parseConditional();
  }

  _Node? tryParseArrow() {
    final start = pos;
    // x => …
    if (peek.type == _T.ident && t[pos + 1].isPunct('=>')) {
      final name = next().value as String;
      pos++;
      return _ArrowNode([name], parseArrowBody());
    }
    if (!peek.isPunct('(')) return null;
    // ( … ) => …  : paramètres simples ou déstructurés {a, b}
    pos++;
    final params = <String>[];
    var ok = true;
    if (acceptPunct('{')) {
      while (!peek.isPunct('}')) {
        if (peek.type != _T.ident) {
          ok = false;
          break;
        }
        params.add(next().value as String);
        if (!acceptPunct(',')) break;
      }
      ok = ok && acceptPunct('}');
    } else {
      while (!peek.isPunct(')')) {
        if (peek.type != _T.ident) {
          ok = false;
          break;
        }
        params.add(next().value as String);
        if (!acceptPunct(',')) break;
      }
    }
    if (ok && acceptPunct(')') && acceptPunct('=>')) {
      return _ArrowNode(params, parseArrowBody());
    }
    pos = start;
    return null;
  }

  _Node parseArrowBody() {
    if (peek.isPunct('{') && !_looksLikeObjectLiteral()) {
      pos++;
      if (peek.isIdent('return')) pos++;
      final body = parseExpression();
      acceptPunct(';');
      expectPunct('}');
      return body;
    }
    return parseAssignmentLike();
  }

  bool _looksLikeObjectLiteral() =>
      (t[pos + 1].type == _T.ident || t[pos + 1].type == _T.str) &&
      t[pos + 1].value != 'return' &&
      t[pos + 2].isPunct(':');

  _Node parseConditional() {
    final test = parseNullish();
    if (acceptPunct('?')) {
      final consequent = parseAssignmentLike();
      expectPunct(':');
      final alternate = parseAssignmentLike();
      return _ConditionalNode(test, consequent, alternate);
    }
    return test;
  }

  _Node parseNullish() {
    var left = parseOr();
    while (acceptPunct('??')) {
      left = _BinaryNode('??', left, parseOr());
    }
    return left;
  }

  _Node parseOr() {
    var left = parseAnd();
    while (acceptPunct('||')) {
      left = _BinaryNode('||', left, parseAnd());
    }
    return left;
  }

  _Node parseAnd() {
    var left = parseEquality();
    while (acceptPunct('&&')) {
      left = _BinaryNode('&&', left, parseEquality());
    }
    return left;
  }

  _Node parseBinaryLevel(List<String> ops, _Node Function() operand) {
    var left = operand();
    while (true) {
      final op = ops.firstWhere((o) => peek.isPunct(o), orElse: () => '');
      if (op.isEmpty) return left;
      pos++;
      left = _BinaryNode(op, left, operand());
    }
  }

  _Node parseEquality() =>
      parseBinaryLevel(['===', '!==', '==', '!='], parseRelational);

  _Node parseRelational() =>
      parseBinaryLevel(['<=', '>=', '<', '>'], parseAdditive);

  _Node parseAdditive() => parseBinaryLevel(['+', '-'], parseMultiplicative);

  _Node parseMultiplicative() =>
      parseBinaryLevel(['*', '/', '%'], parseUnary);

  _Node parseUnary() {
    for (final op in ['!', '-', '+']) {
      if (acceptPunct(op)) return _UnaryNode(op, parseUnary());
    }
    if (peek.isIdent('typeof')) {
      pos++;
      return _UnaryNode('typeof', parseUnary());
    }
    return parsePostfix(parsePrimary());
  }

  _Node parsePostfix(_Node node) {
    while (true) {
      if (acceptPunct('.')) {
        node = _MemberNode(node, _Literal(expectName()));
      } else if (acceptPunct('?.')) {
        if (acceptPunct('(')) {
          node = _CallNode(node, parseArgs(), optional: true);
        } else if (acceptPunct('[')) {
          final prop = parseExpression();
          expectPunct(']');
          node = _MemberNode(node, prop, optional: true);
        } else {
          node = _MemberNode(node, _Literal(expectName()), optional: true);
        }
      } else if (acceptPunct('[')) {
        final prop = parseExpression();
        expectPunct(']');
        node = _MemberNode(node, prop);
      } else if (acceptPunct('(')) {
        node = _CallNode(node, parseArgs());
      } else if (peek.isIdent('as') && t[pos + 1].type == _T.ident) {
        // Cast Dart laissé par TsToDartConverter (`x as bool`) : sans effet
        pos += 2;
      } else {
        return node;
      }
    }
  }

  String expectName() {
    final tok = next();
    if (tok.type != _T.ident) {
      throw JsEvalException("Nom de propriété attendu, trouvé '${tok.value}'");
    }
    return tok.value as String;
  }

  List<_Node> parseArgs() {
    final args = <_Node>[];
    while (!peek.isPunct(')')) {
      args.add(parseAssignmentLike());
      if (!acceptPunct(',')) break;
    }
    expectPunct(')');
    return args;
  }

  _Node parsePrimary() {
    final tok = next();
    switch (tok.type) {
      case _T.num:
      case _T.str:
        return _Literal(tok.value);
      case _T.ident:
        return switch (tok.value) {
          'true' => _Literal(true),
          'false' => _Literal(false),
          'null' => _Literal(null),
          _ => _Identifier(tok.value as String),
        };
      case _T.punct:
        if (tok.value == '(') {
          final inner = parseExpression();
          expectPunct(')');
          return inner;
        }
        if (tok.value == '[') {
          final items = <_Node>[];
          while (!peek.isPunct(']')) {
            items.add(parseAssignmentLike());
            if (!acceptPunct(',')) break;
          }
          expectPunct(']');
          return _ArrayNode(items);
        }
        if (tok.value == '{') {
          final entries = <MapEntry<String, _Node>>[];
          while (!peek.isPunct('}')) {
            final key = next();
            if (key.type != _T.ident && key.type != _T.str && key.type != _T.num) {
              throw JsEvalException("Clé d'objet invalide '${key.value}'");
            }
            final name = _toJsString(key.value);
            if (acceptPunct(':')) {
              entries.add(MapEntry(name, parseAssignmentLike()));
            } else {
              // Propriété abrégée `{a}`
              entries.add(MapEntry(name, _Identifier(name)));
            }
            if (!acceptPunct(',')) break;
          }
          expectPunct('}');
          return _ObjectNode(entries);
        }
        throw JsEvalException("Symbole inattendu '${tok.value}'");
      case _T.eof:
        throw JsEvalException("Fin d'expression inattendue");
    }
  }
}
