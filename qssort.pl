/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * from course website
 */
read_input(File, M, D) :-
    open(File, read, Stream),
    read_line(Stream, M),
    read_line(Stream, D).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).



% do a Q move
% if same elements, move them together
qmove([H|T],S,M,Q2,S2):-
  (T=[H|_] -> append([q],M2,M), qmove(T,[H|S],M2,Q2,S2)
  ;Q2=T, S2=[H|S], M=[q]).

% do an S move
% if same elements, move them together
smove(Q,[H|T],M,Q2,S2):-
  (T=[H|_] -> append([s],M2,M), append(Q,[H],Q3), smove(Q3,T,M2,Q2,S2)
  ;append(Q,[H],Q2), S2=T, M=[s]).

% Check for Q move before S move
move([H|T],S,M,Q2,S2):-
  qmove([H|T],S,M,Q2,S2).
move(Q,[H|T],M,Q2,S2):-
  smove(Q,[H|T],M,Q2,S2).

% predicate where Moves is a list of q,s moves that sort Q into Sorted
% returns results in order of least amount of moves by calling length
% calls helper predicate with 4 arguments, starting with empty stack
solve(Q,Moves,Sorted):-
  length(Moves,_),
  solve(Q,[],Moves,Sorted).
% helper predicate
% solved if stack is empty and queue Q is sorted
solve(Q,[],_,Sorted):-
  Q=Sorted.
% helper predicate
% Q is current queue, S is current stack, Sorted is final result
% Q2 and S2 are queue and stack after Move
% Moves is list of moves
solve(Q,S,[Move|Moves],Sorted):-
  move(Q,S,Move,Q2,S2),
  solve(Q2,S2,Moves,Sorted).
% to give only one solution
solve1(Q,Moves,Sorted):-
  once(solve(Q,Moves,Sorted)).


qssort(File,Answer) :-
  read_input(File,_,D),
  msort(D,Sorted),
  (Sorted=D -> Answer="empty"
  ; solve1(D,Moves,Sorted),
    flatten(Moves,Flat),
    atomics_to_string(Flat,Lower),
    string_upper(Lower,Answer)
    ).
