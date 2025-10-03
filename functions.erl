-module(functions).
-compile(export_all).  %% REPLACE WITH SPECIFIC EXPORTS LATER

head([H|_]) -> H.
second([_,X|_]) -> X.

same(X,X) ->
    true;
same(_,_) ->
    false.

old_enough(X) when X >= 16, X =< 104 -> true;
old_enough(_) -> false.