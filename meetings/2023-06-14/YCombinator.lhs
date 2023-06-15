> module YCombinator where

First, consider the standard recursive definition of the `factorial` function.

> factorial :: Int -> Int
> factorial n = if n == 0 then 1 else n * factorial (n - 1)

How do we reformulate this as to delegate the recursion to the Y combinator?

Let's start by writing down the Y combinator?

> ycomb :: (a -> a) -> a
> ycomb f = f (ycomb f)

We now reformulate the `factorial` function as to abstract out the
recursive call

> factorial0 :: Int -> Int
> factorial0 n = (\f -> if n == 0 then 1 else n * f (n - 1)) factorial0

We have completely factored out the code that performs the recursive call. Let's
give a name to this function.

> factorialBody :: (Int -> Int) -> (Int -> Int)
> factorialBody f = \n -> if n == 0 then 1 else n * f (n - 1)

Now `factorial` can be rewritten simply as

> factorial1 :: Int -> Int
> factorial1 = factorialBody factorial1

But the recursion is still done by implicit use of a Haskell function's ability
to call to itself. How do we abstract out the recursion as well?

Repeatedly unfolding `factorial1` gives

```haskell
factorial1 = factorialBody (factorialBody (factorialBody ...
```

What's going on here is nothing but the repeated application of a function to
itself infinitely many times.

Can we abstract out the operation of repeatedly self-applying a function
infinitely many times? Yes, in fact we have already done this: that's exactly
what `ycomb` does.

```haskell
ycomb f = f (ycomb f) = f (f (ycomb f)) = f (f (f ...
```

So at this point, it should be completely clear how to rewrite `factorial` using
the Y combinator:

> factorial2 :: Int -> Int
> factorial2 = ycomb factorialBody
