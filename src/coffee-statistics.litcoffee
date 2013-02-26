[median](http://en.wikipedia.org/wiki/Median) is the
'middle number' of a list. often medians are useful
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

    sum = (x) ->
        sum = 0;
        sum += a for a in x
        sum;

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

        Math.pow value, 1 / x.length;
