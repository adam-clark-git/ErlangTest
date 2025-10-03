-module(useless).

-export([add/2, hello/0, greet_and_add_two/1]).

add(A,B) ->
    A + B.

%% Shows Greetings.
% I'm following a tutorial!
hello() ->
    io:format("Hello World~n").

greet_and_add_two(X) ->
    hello(),
    add(X,2).