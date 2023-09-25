# Student Schedules
> Here's a logic puzzle that seeks to determine which students take classes on which days.

*This comes from an exercise contained with materials I have been given to teach a university-level course on Artificial Intelligence*.

## Background
There are four students
1. Adam
2. Berta
3. Caesar
4. Dora

who take the same course but on different days.  One student takes it on each of the following days:
* Monday
* Tuesday
* Wednesday
* Thursday

We want to figure out which student takes the class on which day.

## Hints
* Adam is not at the university on Thursday
* Adam always learns from Berta which tasks are covered in class
* Dora always goes to class one day before Caesar

## Explanation

### Starting state
There are 4! = 24 unique arrangements of the possible schedules.

The code below generates `4^4 = 256` instances, which includes pairings in which all students attend classes on the same day:

```
% define the students
student(a). 	%Adam
student(b). 	%Berta
student(c). 	%Caesar
student(d).	%Dora

% define the days
day(1).		%Monday
day(2).		%Tuesday
day(3).   	%Wednesday
day(4).		%Thursday

% all arrangements with replacement
1 { pair(S,D) : student(S), day(D) } 1 :- student(S).
```

Since each day is only occupied by one student, we need to add an additional check, which gives us the desired 24 possibilities:
```
% only one student per day
:- not 1 {pair(S,D) : student(S)} 1, day(D).
```

### Including the hints

#### Hint No. 1
The first hint states that Adam doesn't attend class on Thursday, which eliminates six results in which Adam attends class on Thursday and subsequently leaves us with 18:
```
:- pair(a,4).
```

#### Hint No. 2
The second hint states that Adam learns of the week's topics from Berta, which implies that Berta must attend class earlier in the week than Adam.  The following code states that *it cannot be the case that the day Berta goes to class `Y` may be larger than (come after) the day that Adam goes to class `X`*.
```
:- pair(a,X), pair(b,Y), Y>X.
```

This hint eliminates 12 results and leaves us with six:
```
clingo version 5.6.2
Reading from stdin
Solving...
Answer: 1
pair(a,3) pair(b,1) pair(c,2) pair(d,4)
Answer: 2
pair(a,3) pair(b,1) pair(d,2) pair(c,4)
Answer: 3
pair(b,2) pair(a,3) pair(c,1) pair(d,4)
Answer: 4
pair(b,2) pair(a,3) pair(d,1) pair(c,4)
Answer: 5
pair(a,2) pair(b,1) pair(c,3) pair(d,4)
Answer: 6
pair(a,2) pair(b,1) pair(d,3) pair(c,4)
SATISFIABLE

Models       : 6
Calls        : 1
Time         : 0.003s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.001s
```

#### Hint No. 3
The third hint states that Dora always goes to class one day before Caesar.  This is more explicit, and is the key in determining the sole solution.  It can be coded in the following manner, which states that *it cannot be the case that the day Dora goes to class `X` is **not** equal to one less than (does not come one day before) the day Caesar goes to class `Y`*.
```
:- pair(d,X), pair(c,Y), not X = Y-1.
```

This gives us the correct solution:
* Berta goes on Monday
* Adam goes on Tuesday
* Dora goes on Wednesday
* Caesar goes on Thursday

And we can see that in just a few lines of code, we can quickly determine the answer to this logic puzzle, and see the intermediate steps contained within.
