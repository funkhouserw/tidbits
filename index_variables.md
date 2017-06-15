# Be careful with your loops

## Indexing variables are instantiated as local or global variables outside of the loop block. 
#### Wilson Funkhouser

Having been raised as a rubyist, I always had to be fairly explicit with the
scope of any variables I was interacting with.  Now that I'm learning Python and
R, I'm learning this isn't the case, even with other languages like javascript,
  which I thought I was fairly comfortable with. 

What exactly do I mean? Let's look at some Ruby code..

```
# Ruby
(1..10).each do |i|
    puts i
    foo = i
end

puts i #Error! i doesn't exist!
puts foo #Error! foo doesn't exist!
```

We instantiated two variables in that block, _i_ and _foo_. In ruby, every
single gosh-darned method-definition block (class, module, def) has its own 
local scope. Even if 'i' exists in one scope, it won't interfere with a
different scope.  Once that block is done executing, those variables reset
to an undefined state. 

This was super nice as a sometimes-lazy, more-often-incompetent developer. 
You can toss variables around, but if you want to get something out of a loop or
method, you have to explicitly declare it as belonging to a larger scope or just
pass it around.

This isn't the case with javascript 

``` 
# javascript
for (i = 0; i < 10; i++) { 
    var text = "blah";
}
text
# > "blah"
i
#> 10
```

First of all, `text` is defined outside of the block, which was surprising. It
turns out you can use `let` to limit the scope of a variable to a block, though. 

```
for (i = 0; i < 10; i++) { 
    let text2 = "blah";
}
text2
# > Uncaught ReferenceError: text2 is not defined(..)
```
But uhh, notice anything else? `i` is instantiated outside of the block. In
fact, as I wrote it, this will be global in scope. 

To have both of these exist only for the execution of the loop block, we can
just use `let` twice.

```
# javascript
for (let i=0;i < 10; i++) {
  pass
}
i
# > Uncaught ReferenceError: i is not defined(...)
```

This lets us do some crazy stuff like stop a loop and continue it later. 
```
# javascript
for (i = 0; i < 10; i++) { 
    var text = i;
    if(i > 5) {
        break;
    }
}
text
# > 6
for(i;i < 10; i++){
  console.log(i);
  text = i;
}
# > 6
# > 7
# > 8
# > 9

```

The same instantiation rules apply to Python, except there's no `let`
equivalent.

```
# Python

for i in range(0,10):
   text = i

# and now that we're outside of the loop block...
text
# > 9
i
# > 9
```

There are two cool sidenotes here. The first is that there's a python convention
to use and underscore, `_` when you use a throwaway variable in a loop.
```
# Python
for _ in range(0,5):
  print("hello")
# > hello
# > hello
# > hello
# > hello
# > hello
```

This still instantiates `_` as a local variable, but in theory future editors of
your code will know what it means. This doesn't sound very python-y to me -- the
code is supposed to speak for itself. 

The second tidbit is that, if your range is empty, the indexing variable won't
be intantiated at all. 

```
# Python
for i in []:
    pass
print(i)
# >  NameError: name 'i' is not defined
```
[source for this info and example](http://eli.thegreenplace.net/2015/the-scope-of-index-variables-in-pythons-for-loops/)

This is all also true in R and a whole slew of other languages. One example of
weird scoping tricks has some hilarious and telling examples in R.  Read the
whole thing
[here](http://andrewgelman.com/2014/01/29/stupid-r-tricks-random-scope/) .
Spoilers: it culminates in a function that will randomly
decide to use the globally defined variable or the locally defined variable. 

```
> b <- 20
> h <- function(x) { if (rbinom(1,1,0.5)) { b <- 1000 }; return(b * x); }
and then call it a few times

> h(2)
[1] 40

> h(2)
[1] 2000
Whether the value of b is the local variable set to 1000 or the global value set to 20 depends on the outcome of the coin flip determined by calling rbinom(1,1,0.5)!
```
[source](http://andrewgelman.com/2014/01/29/stupid-r-tricks-random-scope/)

## Ok, why?! 

This feels so much cleaner in Ruby! Why is it so common and accepted to let
these indexing variables exist once their block has been created by default?

Well, in the case of Python the answer is basically, ["Changing this would break
existing code"](https://mail.python.org/pipermail/python-ideas/2008-October/002109.html) 
, which is always the best answer for a language to behave the way it does. 

In javascript, at least, `let` gives us an easy and understandable way around
this issue. I guess we could cleanup our python variables with `del` once we're
done with them, but needing to explicitly delete these variables seems like such
a pain.  Well, in every of these languages, we do have a simple, universal-ish solution. 

## Just put it in a function. 

Just put it in a function. Problem solved. In Python, R, Javascript, Ruby, and pretty much everything else,
variables not declared as global are going to remain local to that
block or function. 

"in a function" is a bit specific. You want to use _closures_ for lexical
scoping. 

In R, this would look like:
```
> ff <- function(x) { g <- function(y) { return(x * y) }; return(g) }

> ff(7)(9)
[1] 63
```
"What's going on is that R uses the scope of a variable at the point at which the function is defined and that inner function g is not defined until the function ff is called."
[source](http://andrewgelman.com/2014/01/29/stupid-r-tricks-random-scope/)


What an anti-climactic ending. I don't necessarily like this as a design
decision for Python, but given how function-centric it is, I can at least
understand it and easily follow it.  For R... as long as I'm aware and
understand closures, I'm sure I'll manage. But this is going to be one hell of a
bug to pick up on for larger/more serious projects written in R. 

If you know why this decision was made in R, please let me know. I haven't been
able to find out why the creators of the language made this decision, especially
since this behavior of indexing variables is not how Java or C function, as far
as I know. 

[update: source documentation on scoping in R with a little bit of insight as to
'why'](https://socserv.socsci.mcmaster.ca/jfox/Books/Companion-1E/appendix-scope.pdf)
