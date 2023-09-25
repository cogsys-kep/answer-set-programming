% define the students
student(a). 
student(b). 
student(c). 
student(d).

% define the days
day(1).
day(2).
day(3).
day(4).

% all arrangements with replacement (256)
1 { pair(S,D) : student(S), day(D) } 1 :- student(S).

% only one student per day (24)
:- not 1 {pair(S,D) : student(S)} 1, day(D).

% hints   
:- pair(a,4). %hint #1
:- pair(a,X), pair(b,Y), Y>X. %hint #2
:- pair(d,X), pair(c,Y), not X = Y-1. %hint #3
