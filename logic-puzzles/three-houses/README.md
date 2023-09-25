# Three Houses
> Here's a logic puzzle that seeks to determine who's in what house and what they like to drink.

*This comes from an exercise contained with materials I have been given to teach a university-level course on Artificial Intelligence*.

## Background
There are three houses.
* There are three different colors of the houses' exteriors: red, green, and turquoise
* There are residents of three different nationalities: german, french, and italian
* There are three different preferred drinks of the inhabitants: beer, wine, and champagne

Each attribute appears once and is therefore unique to the house it belongs to.

For each of the three houses, we want to know its color, the nationality of its resident, and the preferred drink inside the house.

## Hints
* The **German** lives in the **green** house
* The preferred drink of the **Italian** is **champaign**
* The preferred drink of the resident of **House 3** is **wine**
* The resident of **House 2** does *not* drink **champagne**
* The resident whose favorite drink is **wine** lives next to the **red** house

## Explanation

### Starting state
There are `216` unique arrangements.  The code below generates these arrangements:

```
% define the houses
house(1).
house(2).
house(3).

% define the colors
color(red).
color(green).
color(turq).

% define the nationalities
nationality(german).
nationality(italian).
nationality(french).

% define the drinks
drink(beer).
drink(wine).
drink(champ).

% generate all possibilities - 216 possibilities
1 { combo(H,C,N,D) : house(H), color(C), nationality(N), drink(D) } 1 :- house(H).
    
% each color may only appear once
:- not { combo(H,C,N,D) : color(C) } = 1, color(C).
    
% each nationality may only appear once
:- not { combo(H,C,N,D) : nationality(N) } = 1, nationality(N).
    
% each drink may only appear once
:- not { combo(H,C,N,D) : drink(D) } = 1, drink(D).
```

### Hint No. 1
> The **German** lives in the **green** house.

This brings us down to a total of 72 possibilities:
```
:- not combo(_, green, german, _).
```
### Hint No. 2
> The preferred drink of the **Italian** is **champagne**.

This brings us down to a total of 24 possibilities:
```
:- not combo(_, _, italian, champ).
```

### Hint No. 3
> The preferred drink of the resident of **House 3** is **wine**.

This brings us down to just 8 possibilities:
```
:- not combo(3, _, _, wine).
```

### Hint No. 4
> The resident of **House 2** does *not* drink **champagne**.

This leaves us with 4 possibilities, which don't include the resident of House 2 preferring champagne:
```
:- combo(2, _, _, champ).
```

Results:
```
clingo version 5.6.2
Reading from stdin
Solving...
Answer: 1
combo(3,green,german,wine) combo(1,red,italian,champ) combo(2,turq,french,beer)
Answer: 2
combo(3,green,german,wine) combo(1,turq,italian,champ) combo(2,red,french,beer)
Answer: 3
combo(3,turq,french,wine) combo(1,red,italian,champ) combo(2,green,german,beer)
Answer: 4
combo(3,red,french,wine) combo(1,turq,italian,champ) combo(2,green,german,beer)
SATISFIABLE

Models       : 4
Calls        : 1
Time         : 0.005s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.003s
```

### Hint No. 5
> The resident whose favorite drink is **wine** lives _next to_ the **red** house.

This actually has two crucial pieces of information:
1. Clearly, we can see that the resident of the red house is different from the resident who prefers wine
2. Additionally, we know that the houses must actually be beside one another—that means one can't be House 1 while the other is House 3

Out of the four results above, only one of them fits this criterion.
* In Answer 4, House 3 is red and has the wine drinker—which violates the first observation
* In Answers 1 and 3, House 1 is red and House 3 has the wine drinker—which violate the second observation

We can encode this constraint by recognizing two combiations, one with house number `HX` that has the wine drinker, and one with house number `HY` which is red.  We say that *it cannot be the case the the absolute difference between these two house numbers is not 1*.

```
:- combo(HX, _, _, wine), combo(HY, red, _, _), |HX-HY| !=  1.
```

This gives us the correct response:
1. House 1 is turquoise and has an Italian resident who prefers champagne
2. House 2 is red and has a French resident who prefers beer
3. House 3 is green and has a German resident who prefers wine

Despite having many initial combinations, with just five hints, we can logically narrow it down to a single unique answer.
