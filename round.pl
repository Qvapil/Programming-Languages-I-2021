read_input(File, M, N, D) :-
    open(File, read, Stream),
    read_line(Stream, [M,N]),
    read_line(Stream, D).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

% predicate to find how many cars in each town (assumes input list is sorted)
freqlist([],[H2|T2],Towns,Index,Current):-
  ((Index is Towns-1)->(L=[H2|T2], L=[Current])
  ; (I2 is Index+1, H2=Current, freqlist([],T2,Towns,I2,0))
  ).
freqlist([H1|T1],[H2|T2],Towns,Index,Current):-
  ((H1=Index) -> (C2 is Current+1, freqlist(T1,[H2|T2],Towns,Index,C2))
  ;(H1>Index) -> (I2 is Index+1, H2=Current, freqlist([H1|T1],T2,Towns,I2,0))
  ).

% predicate to find distance of each car to town 0, result in list [H2|T2]
state0([],_,[]).
state0([H|T],Towns,[H2|T2]):-
  (H=0 -> H2=0 ; H2 is Towns-H),
  state0(T,Towns,T2).

% list of towns with cars
townsWithCars([],[],_).
townsWithCars([H1|T1],L,Index):-
  I2 is Index+1,
  ((H1=0)-> townsWithCars(T1,L,I2)
  ;L=[H2|T2], H2=Index, townsWithCars(T1,T2,I2)).


% check goes through frequency list and finds sum and max for each final town
% max is found by going through townsWithCars list because
% max distance town is always the next town with cars right of current town
% sum is found by using previous sum and moving cars one town forward
% an answer is valid only if the max distance is at most 1 more than the sum
% of all the other distances cars have to travel, so they can alternate
% if found valid answer, check if sum is smaller than current sum

% final check, merge accumulators with final answers
check([],_,_,_,_,Indfinal,Sumfinal,Sumacc,_,Indacc):-
  Sumfinal=Sumacc, Indfinal=Indacc.
% max distance town =current town, move max distance town to the right
check(L1,[H2|T2],I1,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sumcur,Indacc):-
  I1=H2, check(L1,T2,I1,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sumcur,Indacc).
% special case where current town is 0, check if solution is valid
check([_|T1],[H2|T2],0,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sumcur,Indacc):-
  Max0 is mod(Towns-H2,Towns),
  ((Sumcur-Max0+1>=Max0)->
    check(T1,[H2|T2],1,Cars,Towns,Indfinal,Sumfinal,Sumcur,Sumcur,Indacc)
  ;check(T1,[H2|T2],1,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sumcur,Indacc)).
% general predicate, find max and new sum, check if solution is valid,
% update if better valid solution, and check next town
check([H1|T1],[H2|T2],I1,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sumcur,Indacc):-
  I1new is I1+1, Max2 is mod(Towns+I1-H2,Towns), Sum2 is Sumcur+Cars-Towns*H1,
  ((Sum2-Max2+1>=Max2, Sum2<Sumacc)->
    (check(T1,[H2|T2],I1new,Cars,Towns,Indfinal,Sumfinal,Sum2,Sum2,I1))
  ;check(T1,[H2|T2],I1new,Cars,Towns,Indfinal,Sumfinal,Sumacc,Sum2,Indacc)
  ).

% general predicate, does the following steps:
% read file
% sort input and call freqlist to get list of how many cars in each town (Ar2)
% call townsWithCars to get list of towns that have cars in them (Ar3)
% double Ar3 because we want to loop to start, this takes care of it (Ar4)
% call state0 on sorted input to get list of distances cars must travel to reach town 0
% get the sum of distances to state0
% A0 = upper bound sum answer, assume all cars must take Towns number of steps
% call check once to get the answer, with parametres:
% frequency list, townsWithCars list, index 0, number of cars, number of towns,
% C,M, upper bound answer, initial sum to state0 (accumulator), index 0 (accum)
round(File,M,C) :-
      read_input(File,Tnum,Cnum,Ar1),
      msort(Ar1,Sorted),
      freqlist(Sorted,Ar2,Tnum,0,0),
      townsWithCars(Ar2,Ar3,0),
      append(Ar3,Ar3,Ar4),
      state0(Sorted,Tnum,S0),
      sumlist(S0,Sum0),
      Ac0 is Tnum*Cnum,
      once(check(Ar2,Ar4,0,Cnum,Tnum,C,M,Ac0,Sum0,0)).
