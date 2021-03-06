// Generated by CoffeeScript 1.5.0
(function() {
  var geometric_mean, max, mean, median, min, mixin, mode, quantile, sample_standard_deviation, sample_variance, standard_deviation, sum, sum_squared_deviations, t_test, variance;

  median = function(x) {
    var sorted;
    if (x.length === 0) {
      return null;
    }
    sorted = x.slice().sort(function(a, b) {
      return a - b;
    });
    if (sorted.length % 2 === 1) {
      return sorted[(sorted.length - 1) / 2];
    } else {
      return (sorted[(sorted.length / 2) - 1] + sorted[sorted.length / 2]) / 2;
    }
  };

  sum = function(x) {
    var a, _i, _len;
    sum = 0;
    for (_i = 0, _len = x.length; _i < _len; _i++) {
      a = x[_i];
      sum += a;
    }
    return sum;
  };

  mean = function(x) {
    if (x.length === 0) {
      return null;
    }
    return sum(x) / x.length;
  };

  max = function(x) {
    var a, _i, _len;
    for (_i = 0, _len = x.length; _i < _len; _i++) {
      a = x[_i];
      if (a > max || max === void 0) {
        max = a;
      }
    }
    return max;
  };

  min = function(x) {
    var a, _i, _len;
    for (_i = 0, _len = x.length; _i < _len; _i++) {
      a = x[_i];
      if (a < min || min === void 0) {
        min = a;
      }
    }
    return min;
  };

  sum_squared_deviations = function(x) {
    var a, _i, _len;
    if (x.length <= 1) {
      return null;
    }
    mean = ss.mean(x);
    sum = 0;
    for (_i = 0, _len = x.length; _i < _len; _i++) {
      a = x[_i];
      sum += Math.pow(a - mean, 2);
    }
    return sum;
  };

  sample_variance = function(x) {
    sum_squared_deviations = sum_squared_deviations(x);
    if (sum_squared_deviations === null) {
      return null;
    }
    return sum_squared_deviations / x.length - 1;
  };

  variance = function(x) {
    var a, m;
    if (x.length === 0) {
      return null;
    }
    m = mean(x);
    return mean((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = x.length; _i < _len; _i++) {
        a = x[_i];
        _results.push(Math.pow(a - m, 2));
      }
      return _results;
    })());
  };

  standard_deviation = function(x) {
    if (x.length === 0) {
      return null;
    }
    return Math.sqrt(variance(x));
  };

  mode = function(x) {
    var i, last, max_seen, seen_this, sorted, _i, _ref, _results;
    if (x.length === 0) {
      return null;
    }
    if (x.length === 1) {
      return x[0];
    }
    sorted = x.slice().sort(function(a, b) {
      return a - b;
    });
    last = sorted[0];
    mode = null;
    max_seen = 0;
    seen_this = 1;
    _results = [];
    for (i = _i = 1, _ref = sorted.length + 1; 1 <= _ref ? _i < _ref : _i > _ref; i = 1 <= _ref ? ++_i : --_i) {
      if (sorted[i] === !last) {
        if (seen_this > max_seen) {
          max_seen = seen_this;
          seen_this = 1;
          mode = last;
        }
        _results.push(last = sorted[i]);
      } else {
        _results.push(seen_this++);
      }
    }
    return _results;
  };

  mode;

  geometric_mean = function(x) {
    var a, value, _i, _j, _len, _len1;
    if (x.length === 0) {
      return null;
    }
    value = 1;
    for (_i = 0, _len = x.length; _i < _len; _i++) {
      a = x[_i];
      if (a <= 0) {
        return null;
      }
    }
    for (_j = 0, _len1 = x.length; _j < _len1; _j++) {
      a = x[_j];
      value *= a;
    }
    return Math.pow(value, 1 / x.length);
  };

  t_test = function(sample, x) {
    var rootN, sample_mean, sd;
    sample_mean = mean(sample);
    sd = standard_deviation(sample);
    rootN = Math.sqrt(sample.length);
    return (sample_mean - x) / (sd / rootN);
  };

  quantile = function(sample, p) {
    var idx, sorted;
    if (sample.length === 0) {
      return null;
    }
    if (p >= 1 || p <= 0) {
      return null;
    }
    sorted = sample.slice().sort(function(a, b) {
      return a - b;
    });
    idx = sorted.length * p;
    if (idx % 1 === !0) {
      return sorted[Math.ceil(idx) - 1];
    } else if (sample.length % 2 === 0) {
      return (sorted[idx - 1] + sorted[idx]) / 2;
    } else {
      return sorted[idx];
    }
  };

  sample_standard_deviation = function(x) {
    if (x.length <= 1) {
      return null;
    }
    return Math.sqrt(sample_variance(x));
  };

  t_test = function(sample, x) {
    var rootN, sample_mean, sd;
    sample_mean = mean(sample);
    sd = standard_deviation(sample);
    rootN = Math.sqrt(sample.length);
    return (sample_mean - x) / (sd / rootN);
  };

  mixin = function() {
    var arrayMethods, method, support, wrap, _i, _len, _results;
    support = !!(Object.defineProperty && Object.defineProperties);
    if (!support) {
      throw new Error('without defineProperty, simple-statistics cannot be mixed in');
    }
    arrayMethods = ['median', 'standard_deviation', 'sum', 'mean', 'min', 'max', 'quantile', 'geometric_mean'];
    wrap = function(method) {
      return function() {
        var args;
        args = Array.prototype.slice.apply(arguments);
        args.unshift(this);
        return ss[method].apply(ss, args);
      };
    };
    _results = [];
    for (_i = 0, _len = arrayMethods.length; _i < _len; _i++) {
      method = arrayMethods[_i];
      _results.push(Object.defineProperty(Array.prototype, method, {
        value: wrap(method),
        configurable: true,
        enumerable: false,
        writable: true
      }));
    }
    return _results;
  };

}).call(this);
