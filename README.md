# Genki — a composable sequence/iterator abstraction library (in progress)

Genki is a library providing abstractions over Swift sequences, allowing various common algorithms and operations to be implemented by composing them. In many cases, Genki's algorithms will be faster than using map/filter/reduce, due to not allocating and disposing intermediate structures.

## What's currently included:

- **SubsamplingSequence** — a `Sequence` that wraps another `Sequence` and produces a sequence of values computed by performing an arbitrary operation on each set of a fixed number of its elements. Each span is represented by a `bucket` value, which conforms to the `SubsamplingBucket` protocol and consumes elements to produce a sequence of Buckets, each of which contains the result for its set of samples.

For example: if one has a sequence of `Double` values and wishes to find the mean value of every 3, values, the code could look like:

```
func meanOfEvery3(source: [Double]) -> [Double] {
    return SubsamplingSequence<[Double],MeanBucket<Double>>(source: source, span: 3).map { $0.mean }
}
```

`SubsamplingSequence` is a generic type, which takes two type parameters: the first is the type of the source sequence, and the second is a *bucket* type; a type which implements the `SubsamplingBucket` protocol and performs the actual computation on the samples in each span. 

A few Bucket typeds are provided as is: these are all parametrised to the sequence element type, and are:

 - **MeanBucket<Element>** — calculate the mean (average) of each span of samples. To do this, instantiate `SubsamplingSequence` with a `MeanBucket<Element>` of the type your sequence is comprised of (this must currently be `Float`, `Double` or `Int`), and for each `MeanBucket` value yielded, take its `.mean` value.

 - **MinMaxBucket<Element>** — find the minimum and maximum values in each span; `Element` must be `Comparable`. Each returned bucket value has two values: `.min` and `.max`, which contain the relevant element values.

## About

Genki is written by Andrew Bulhak and is licenced under the MIT License.
