% Gender facts

male(balarama_varma).
male(swathi_thirunal).
male(uthram_thirunal).
male(ayilyam_thirunal).
male(visakham_thirunal).

female(gowri_lakshmi_bayi).
female(gowri_parvati_bayi).
female(gowri_rukmini_bayi).

% Parent relationships

parent(balarama_varma, gowri_lakshmi_bayi).
parent(balarama_varma, gowri_parvati_bayi).

parent(gowri_lakshmi_bayi, swathi_thirunal).
parent(gowri_lakshmi_bayi, uthram_thirunal).
parent(gowri_lakshmi_bayi, gowri_rukmini_bayi).

parent(gowri_rukmini_bayi, ayilyam_thirunal).
parent(gowri_rukmini_bayi, visakham_thirunal).

% Father rule
father(X,Y):- male(X), parent(X,Y).

% Mother rule
mother(X,Y):- female(X), parent(X,Y).

% Sister rule
sister(X,Y):-
    female(X),
    parent(P,X),
    parent(P,Y),
    X \= Y.

% Brother rule
brother(X,Y):-
    male(X),
    parent(P,X),
    parent(P,Y),
    X \= Y.

% Grandparent rule
grandparent(X,Y):-
    parent(X,Z),
    parent(Z,Y).

% Grandfather
grandfather(X,Y):-
    male(X),
    grandparent(X,Y).

% Grandmother
grandmother(X,Y):-
    female(X),
    grandparent(X,Y).
