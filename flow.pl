% flow.pl
% Glenn G. Chappell
% 2024-04-26
%
% For CS 331 Spring 2024
% Code from Apr 26 - Prolog: Flow of Control


% ***** Preliminaries *****


% Output term (for atom, think: string): write(TERM)
% Output newline: nl
% Both always succeed.

% hello_world/0
% Print hello-world message.
hello_world :- write('Hello, world!'), nl.

% Try:
%   ?- hello_world.

% read/1 reads a Prolog term, which must be followed by a period (.),
% from the standard input and unifies it with the argument. Output from
% write/1 that is done before read/1 may not appear unless the standard
% output is flushed. This can be done with flush/0.

% Try:
%   ?- write('Type a number followed by dot: '), flush, read(X).

% true/0 - always succeeds
% fail/0 - never succeeds

% Try:
%   ?- true.
%   ?- fail.


% ***** Basic Repetition *****


% print_squares/2
% print_squares(a, b) prints a message indicating the squares of
% integers a, a+1, ... up to b, each on a separate line.
print_squares(A, B) :-
    A =< B,
    S is A*A,
    write(A), write(' squared is '), write(S), nl,
    A1 is A+1, print_squares(A1, B).

% Try:
%   ?- print_squares(2, 8).


% ***** Encapsulated Flow *****


% We can also encapsulate the recursion in a predicate.

% myFor/3
% If X is bound, succeed if a <= x <= b.
% If X is free, succeed with X = n for each n with a <= n <= b.
myFor(A, B, X) :- A =< B, X = A.
myFor(A, B, X) :- A =< B, A1 is A+1, myFor(A1, B, X).

% So "myFor" starts a loop. How do we end it?
% One answer: fail.
% "fail" never succeeds; so it always backtracks.

% Try:
%   ?- myFor(1, 5, 3).
%   ?- myFor(1, 5, 7).
%   ?- myFor(1, 5, X).
%   ?- myFor(1, 5, X), write(X), nl.
%   ?- myFor(1, 5, X), write(X), nl, fail.

% print_squares2/2
print_squares2(A, B) :-
    myFor(A, B, I),
        S is I*I,
        write(I), write(' squared is '), write(S), nl,
    fail.  % Here, "fail" means backtrack.

% Try:
%   ?- print_squares2(2, 8).

% SWI-Prolog includes the functionality of "myFor", in the form of
% "between".


% ***** Cut *****


% "!" (read as "cut")
% - Always succeeds.
% - Once a cut has been done:
%   - Backtracking past the cut is not allowed, for the current goal.
%   - Included in this: use of another definition for the current goal
%     is not allowed.

% Cut can be used as something like a "break".

% print_near_sqrt/1
% For X > 0. print_near_sqrt(X) prints largest integer whose square is
% at most X.
print_near_sqrt(X) :-
    X1 is X+1,
    between(1, X1, I),
        I2 is I*I,
    I2 > X, !,
    I1 is I-1, write(I1), nl.

% Try:
%   print_near_sqrt(105).

% Cut can do if ... else.

% Consider the following C++ code.
%
%   void test_big(int n)
%   {
%       if (n > 20)
%           cout << n << " IS A BIG NUMBER!" << endl;
%       else
%           cout << n << " is not a big number." << endl;
%   }
%
% Here it is in Prolog:

% test_big/1
% test_big(+n) prints a message indicating whether n > 20.
test_big(N) :- N > 20, !, write(N), write(' IS A BIG NUMBER!'), nl.
test_big(N) :- write(N), write(' is not a big number.'), nl.

% Try:
%   ?- test_big(100).
%   ?- test_big(2).

% More generally, cut can be used to ensure that only one definition of
% a predicate is used.

% Here is our "gcd" predicate from simple.pl:
gcd(0, B, B).
gcd(A, B, C) :- A > 0, BMA is B mod A, gcd(BMA, A, C).

% And here is a rewritten version, using cut:

% gcd2(+a, +b, ?c)
% gcd2(A, B, C) means the GCD of A and B is C. A, B should be
% nonnegative integers. C should be a nonnegative integer or a free
% variable.
gcd2(0, B, B) :- !.
gcd2(A, B, C) :- A > 0, BMA is B mod A, gcd2(BMA, A, C).

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd2(30, 105, X).
%   ?- gcd2(30, 105, 15).
%   ?- gcd2(30, 105, 14).
% Note that gcd2 lacks the annoying "false" that gcd prints at the end
% of a successful run.

% With cut, we can write "not".

% not/1
% Given a zero-argument predicate or compound term. Succeeds if the
% given term fails.
not(T) :- call(T), !, fail.
not(_).

% Try:
%   ?- not(3 = 3).
%   ?- not(3 = 4).

% SWI-Prolog includes the functionality of "not", in the form of "\+".


% ***** Interaction Example *****


% true/0 always succeeds, but only once.

% myRepeat/0 succeeds an unlimited number of times.
myRepeat.
myRepeat :- myRepeat.

% SWI-Prolog includes the functionality of "myRepeat", in the form of
% "repeat".

% We can use myRepeat to do something like a while-true-break loop.

squares_interact :-
    myRepeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl,
    X = 0, !,
    write('Bye!'), nl.

% Try:
%   ?- squares_interact.

% Here is squares_interact rewritten to do its "break" in the middle of
% the loop. Predicate rest_of_loop helps us do this.

% rest_of_loop/1
% Helper for squares_interact2. Do not call directly.
rest_of_loop(X) :- X = 0, !.
rest_of_loop(X) :-
    write('You typed: '), write(X), nl,
    X2 is X*X,
    write('Its square: '), write(X2), nl,
    nl, fail.

squares_interact2 :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        rest_of_loop(X),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact2.

% We can rewrite squares_interact2 as a single predicate if we know just
% a bit more.

% ";" is OR, just as "," is AND. The precedence of ";" is lower than
% that of ",".

% To deal with precedence issues, and to restrict the effect of a cut,
% use parentheses, as below.

% Now we rewrite squares_interact2 as a single predicate.

squares_interact3 :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        (X = 0, !
        ;write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl, fail),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact3.

