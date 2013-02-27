# [median](http://en.wikipedia.org/wiki/Median)

the 'middle number' of a list. often medians are useful
when the list contains extreme values and the average
would be skewed by outliers

    median = (x) ->

The median of an empty list is null

        return null if (x.length is 0)

Sorting the array makes it easy to find the center, but
use `.slice()` to ensure the original array `x` is not modified

        sorted = x.slice().sort (a, b) -> a - b

If the length of the list is odd, the median is the central number

        if sorted.length % 2 is 1
            sorted[(sorted.length - 1) / 2]
        else

Otherwise, the median is the average of the two numbers
at the center of the list

            (sorted[(sorted.length / 2) - 1] +
            sorted[(sorted.length / 2)]) / 2

# Sum

    sum = (x) ->

The sum is simply all numbers added together, starting with a sum of zero

        sum = 0
        sum += a for a in x
        sum

# Mean

    mean = (x) ->

The mean of no numbers is null, otherwise it is the sum over the number of
numbers.

        return null if x.length is 0
        sum(x) / x.length

# Max

This is simply the maximum number in the set.

This runs on `O(n)`, linear time in respect to the array

    max = (x) ->

On the first iteration of this loop, min is
undefined and is thus made the minimum element in the array

        for a in x
            max = a if a > max or max is undefined
        max

# Min

This is simply the minimum number in the set.

This runs on `O(n)`, linear time in respect to the array

    min = (x) ->

On the first iteration of this loop, min is
undefined and is thus made the minimum element in the array

        for a in x
            min = a if a < min or min is undefined
        min

     sum_squared_deviations = (x) ->
        return null if x.length <= 1

        mean = ss.mean(x)
        sum = 0

        for a in x
            sum += Math.pow(a - mean, 2)
        sum

# [variance](http://en.wikipedia.org/wiki/Variance)

is the sum of squared deviations from the mean

    sample_variance = (x) ->
        sum_squared_deviations = sum_squared_deviations(x)
        return null if sum_squared_deviations is null
        sum_squared_deviations / x.length - 1

# [Variance](http://en.wikipedia.org/wiki/Variance)

is the sum of squared deviations from the mean.
The variance of no numbers is null, otherwise the variance is the
average distance squared from each number to the average of the numbers

    variance = (x) ->
        return null if x.length is 0
        m = mean(x)
        mean(Math.pow(a - m, 2) for a in x)

# [Standard Deviation](http://en.wikipedia.org/wiki/Standard_deviation)

is just the square root of the variance.
The standard deviation of no numbers is null

    standard_deviation = (x) ->
        return null if x.length is 0
        Math.sqrt variance(x)

# [mode](http://bit.ly/W5K4Yt)

This implementation is inspired by [science.js](https://github.com/jasondavies/science.js/blob/master/src/stats/mode.js)

    mode = (x) ->

Handle edge cases:
The median of an empty list is null

        return null if x.length is 0
        return x[0] if x.length is 1

Sorting the array lets us iterate through it below and be sure
that every time we see a new number it's new and we'll never
see the same number twice

        sorted = x.slice().sort((a, b) -> a - b)

This assumes it is dealing with an array of size > 1, since size
0 and 1 are handled immediately. Hence it starts at index 1 in the
array.

        last = sorted[0]

store the mode as we find new modes

        mode = null

store how many times we've seen the mode

        max_seen = 0

how many times the current candidate for the mode
has been seen

        seen_this = 1

end at sorted.length + 1 to fix the case in which the mode is
the highest number that occurs in the sequence. the last iteration
compares sorted[i], which is undefined, to the highest number
in the series

        for i in [1...sorted.length + 1]

were seeing a new number pass by

            if sorted[i] is not last

the last number is the new mode since we saw it more
often than the old one

                if seen_this > max_seen
                    max_seen = seen_this
                    seen_this = 1
                    mode = last
                last = sorted[i]

if this isn't a new number, it's one more occurrence of
the potential mode

            else seen_this++
    mode


# The Geometric Mean

    geometric_mean = (x) ->

The mean of no numbers is null

        return null if x.length is 0

the starting value.

        value = 1

the geometric mean is only valid for lists
of positive values

        for a in x
            return null if a <= 0

        value *= a for a in x

        Math.pow value, 1 / x.length

# [t-test](http://en.wikipedia.org/wiki/Student's_t-test)

This is to compute a one-sample t-test, comparing the mean
of a sample to a known value, x.

in this case, we're trying to determine whether the
population mean is equal to the value that we know, which is `x`
here. usually the results here are used to look up a
[p-value](http://en.wikipedia.org/wiki/P-value), which, for
a certain level of significance, will let you determine that the
null hypothesis can or cannot be rejected.

    t_test = (sample, x) ->

The mean of the sample

      sample_mean = mean sample

The standard deviation of the sample

      sd = standard_deviation sample

Square root the length of the sample

      rootN = Math.sqrt sample.length

Compute the known value against the sample,
returning the t value

      (sample_mean - x) / (sd / rootN)


# quantile

This is a population quantile, since we assume to know the entire
dataset in this library. Thus I'm trying to follow the
[Quantiles of a Population](http://en.wikipedia.org/wiki/Quantile#Quantiles_of_a_population)
algorithm from wikipedia.

Sample is a one-dimensional array of numbers,
and p is a decimal number from 0 to 1. In terms of a k/q
quantile, p = k/q - it's just dealing with fractions or dealing
with decimal values.

    quantile = (sample, p) ->

We can't derive quantiles from an empty list

        return null if sample.length is 0

invalid bounds. Microsoft Excel accepts 0 and 1, but
we won't.

        return null if p >= 1 or p <= 0

Sort a copy of the array. We'll need a sorted array to index
the values in sorted order.

        sorted = sample.slice().sort((a, b) -> a - b)

Find a potential index in the list. In Wikipedia's terms, this
is I<sub>p</sub>.

        idx = sorted.length * p

If this isn't an integer, we'll round up to the next value in
the list.

        if idx % 1 is not 0
            return sorted[Math.ceil(idx) - 1]

If the list has even-length and we had an integer in the
first place, we'll take the average of this number
and the next value, if there is one

        else if sample.length % 2 is 0
            return (sorted[idx - 1] + sorted[idx]) / 2

Finally, in the simple case of an integer value
with an odd-length list, return the sample value at the index.

        else
            return sorted[idx]
