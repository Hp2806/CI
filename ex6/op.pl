op(1, X, Y, Z) :- Z is X + Y.
op(2, X, Y, Z) :- Z is X - Y.
op(3, X, Y, Z) :- Z is X * Y.
op(4, X, Y, Z) :- Y \= 0, Z is X / Y.
get_l(N, L) :- 
    length(L, N),            
    maplist(read_ele, L).    
read_ele(X) :- 
    write('Ele: '), 
    read(X).
menu :-
    repeat,
    nl, write('1.Add 2.Sub 3.Mul 4.Div 5.Uni 6.Int 7.Exit'), nl,
    write('Choice: '), read(C),
    do(C),
    C == 7, !.
do(1) :- write('X: '), read(X), write('Y: '), read(Y), op(1, X, Y, Z), write(Z).
do(2) :- write('X: '), read(X), write('Y: '), read(Y), op(2, X, Y, Z), write(Z).
do(3) :- write('X: '), read(X), write('Y: '), read(Y), op(3, X, Y, Z), write(Z).
do(4) :- write('X: '), read(X), write('Y: '), read(Y), (op(4, X, Y, Z) -> write(Z) ; write('Error')).
do(5) :- 
    write('Size A: '), read(N1), get_l(N1, A),
    write('Size B: '), read(N2), get_l(N2, B),
    append(A, B, T), list_to_set(T, C), write(C).
do(6) :- 
    write('Size A: '), read(N1), get_l(N1, A),
    write('Size B: '), read(N2), get_l(N2, B),
    findall(X, (member(X, A), member(X, B)), C), write(C).
do(7) :- write('Exit').
