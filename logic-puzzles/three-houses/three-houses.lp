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
    
% HINTS
:- not combo(_, green, german, _). %down to 72
:- not combo(_, _, italian, champ). %down to 24
:- not combo(3, _, _, wine). %down to 8
:- combo(2, _, _, champ). %down to 4
:- combo(HX, _, _, wine), combo(HY, red, _, _), |HX-HY| !=  1.
    
#show combo/4.
