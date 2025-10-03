-module(hhfuns).
-compile(export_all).

map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F,T)].
