-module(recursion).
-export([fac/1, len/1, tail_fac/1, duplicate/2, tail_zip/2, quicksort/1]).

fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N - 1).

len([]) -> 0;
len([_|T]) -> 1 + len(T).

tail_fac(N) -> tail_fac(N, 1).

tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) when N > 0 -> tail_fac(N - 1, N * Acc).

duplicate(N,Term) ->
    duplicate(N, Term,[]).
duplicate(0,_,List) -> 
    List;
duplicate(N, Term,List) when N > 0->
    duplicate(N-1, Term, [Term|List]).

tail_zip(XList, YList) -> lists:reverse(tail_zip(XList, YList, [])).
tail_zip([],[], ComList) -> ComList;
tail_zip([X|Xs], [Y|Ys], ComList) ->
    tail_zip(Xs,Ys, [{X,Y}|ComList]).


quicksort([]) -> [];
quicksort([Pivot|Rest]) ->
    {Smaller,Larger} = partition(Pivot, Rest,[],[]),
    quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_,[],Smaller,Larger) -> {Smaller,Larger};
partition(Pivot,[H|T], Smaller,Larger) ->
    if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
       H > Pivot -> partition(Pivot, T, Smaller, [H|Larger])
    end.