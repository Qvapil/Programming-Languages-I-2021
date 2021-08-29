/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * from course website
 */
read_input(File, M, N, D) :-
    open(File, read, Stream),
    read_line(Stream, [M,N]),
    read_line(Stream, D).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

% predicate where 3rd param list is modified 2nd param list
% so that problem becomes "find longest non negative sublist"
modify(_,[],[]).
modify(N,[H1|T1],[H2|T2]):-
H2 is -H1-N, modify(N,T1,T2).

% predicate where 3rd param list is cumulative sums of 2nd param List
% so that problem becomes "find longest distance j-i so that L[j]>=L[i]"
cumsum(_,[],[]).
cumsum(S,[H1|T1],[H2|T2]):-
  H2 is S+H1, cumsum(H2,T1,T2).

% predicate where [HL|TL] stores minimum value of [H|L] up to that point
% Min is utility parameter, initialised to 0 here
lmin([],[],_).
lmin([H|T],[HL|TL],Min):-
  ( H<Min -> HL=H, lmin(T,TL,H)
  ; HL=Min, lmin(T,TL,Min)).

% predicate where L2 stores maximum value of L1 from each element onwards
% rmax/3 is similar to lmin/3, but we must reverse the list before and after
% rmax/2 handles reversing and gives initial Max = last element of L1
rmax(L1,L2):-
  reverse(L1,Rev1),
  Rev1=[H1|_],
  rmax(Rev1,Rev2,H1),
  reverse(Rev2,L2).
rmax([],[],_).
rmax([H|T],[HR|TR],Max):-
  ( H>Max -> HR=H, rmax(T,TR,H)
  ; HR=Max, rmax(T,TR,Max)).

% predicate to solve the problem, solution at Max
% based on same O(N) algorithm as my C++ code
% input Lmin [HL|TL] and Rmax [HR|TR], L1 and R1 are indexes starting from 0
% Acc stores current best answer, unify with Max at the end to get result
% end reached when either list ends
maxdist([],_,_,_,Max,Max).
maxdist(_,[],_,_,Max,Max).
maxdist([HL|TL],[HR|TR],L1,R1,Acc,Max):-
  Dist is R1-L1,
  ( HL=<HR ->
    (Dist>Acc -> Acc2 is Dist
     ; Acc2 is Acc),
     R2 is R1+1,
     maxdist([HL|TL],TR,L1,R2,Acc2,Max)
  ;  L2 is L1+1, maxdist(TL,[HR|TR],L2,R1,Acc,Max)).


longest(File,Answer) :-
  read_input(File,_,N,D),
  modify(N,D,Mod),
  cumsum(0,Mod,Csum),
  lmin([0|Csum],Lmin,0),
  rmax([0|Csum],Rmax),
  maxdist(Lmin,Rmax,0,0,-1,Answer).
