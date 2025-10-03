-module(sudoku).
-compile([debug_info]).
-export([solve/1]).
%%
%% [ 0 0 0 | 0 0 0 | 5 0 4 ]
%% [ 0 9 0 | 0 0 0 | 4 6 0 ]
%% [ 4 0 7 | 0 2 9 | 9 3 5 ]
%% [-------|-------|-------]
%% [ 5 0 0 | 4 0 2 | 8 6 7 ]
%% [ 7 2 0 | 0 0 0 | 0 9 0 ]
%% [ 3 0 0 | 9 0 0 | 5 0 4 ]
%% [-------|-------|-------]
%% [ 0 7 0 | 2 0 6 | 0 3 5 ]
%% [ 9 4 0 | 0 8 1 | 0 7 0 ]
%% [ 0 0 0 | 7 0 0 | 9 0 1 ]
%% cd("/Users/adamb/General/School/CSE 310/Erlang/").
%% c(sudoku).
%% sudoku:solve([[0,6,5,7,0,4,9,3,1], [2,4,3,5,0,0,0,0,0],[0,9,1,3,8,6,0,0,0],[0,2,0,1,0,8,0,0,4], [1,0,0,9,0,0,7,0,2], [3,0,0,6,5,2,8,0,9],[0,8,0,0,0,0,4,0,0], [0,0,7,0,0,0,0,0,0], [0,1,0,0,6,0,5,8,3]]).   
%% sudoku:solve([[0,0,0,0,0,0,0,0,1], [0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0]]).
%% sudoku:solve([[3,0,0,0,4,9,0,0,0], [0,0,0,6,0,0,5,0,1],[7,5,2,0,0,1,0,0,0],[0,0,1,0,0,0,7,0,0], [5,0,0,3,9,6,0,0,0], [0,0,8,1,5,0,0,9,6],[0,0,3,0,1,0,0,6,0], [0,0,4,0,0,0,1,0,0], [0,0,0,0,2,8,0,0,0]]).      
%% [[2,0,0,0,0,0,5,0,4], [0,9,0,0,0,0,4,6,0],[4,0,7,0,2,9,9,3,5],
%% [5,0,0,4,0,2,8,6,7], [7,2,0,0,0,0,0,9,0], [3,0,0,9,0,0,5,0,4],
%% [0,7,0,2,0,6,0,3,5], [9,4,0,0,8,1,0,7,0], [0,0,0,7,0,0,9,0,1]]
solve(Grid) -> solve(Grid, {1, 1}).

solve(Grid, {Row, Col}) when Row > 9-> Grid;
solve(Grid, {Row, Col}) when Col > 9-> solve(Grid, {Row+1, 1});
solve(Grid, {Row, Col}) ->
    %%io:format("Solve is Called.~p~n\n", [{Row, Col}]),
    CellVal = valAt(Grid, {Row, Col}),
    if CellVal /= 0 ->
            solve(Grid,{Row,Col+1});
        true ->
            check_val(Grid, {Row, Col}, 1)
    end.

is_solved(Grid) -> is_solved(Grid,1).
is_solved(Grid, Row) when Row > 9-> true;
is_solved(Grid, Row) ->
    %%io:format("Checking if solved.\n"),
    HasZero = lists:member(0,lists:nth(Row, Grid)),
    if HasZero -> 
            false;
        true -> 
            is_solved(Grid, Row+1)
    end.
is_valid(Grid, {Row, Col}, Val) ->
    not is_in_row(Grid, {Row, Col}, Val) andalso
    not is_in_col(Grid, {Row, Col}, Val) andalso
    not is_in_box(Grid, {Row, Col}, Val).

check_val(Grid, {Row, Col}, I) when I > 9 -> Grid;
check_val(Grid, {Row, Col}, I) ->
    %%io:format("Checking.~p~n\n", [{{Row,Col}, I}]),
    Valid = is_valid(Grid, {Row, Col}, I),
    %%io:format("~p~n\n", [Valid]),
    if (Valid) ->
            New_grid = replace_val(Grid, {Row, Col}, I),
            Solved_grid = solve(New_grid, {Row, Col}),
            Solve_status = is_solved(Solved_grid),
            if Solve_status -> 
                    Solved_grid;
                true->
                    check_val(Grid,{Row,Col},I+1)
            end;
            %% If not valid, then check if i+1 is.
        true -> 
            check_val(Grid,{Row,Col},I+1)
    end.


is_in_row(Grid, {Row, Col}, Val) -> lists:member(Val, lists:nth(Row, Grid)).
%% Should go through each element in the column, add them to a list, and then members them
is_in_col(Grid, {Row, Col}, Val) -> lists:member(Val,is_in_col(Grid, {Row,Col}, Val, 1)).
is_in_col(Grid, {Row, Col}, Val, I) when I > 9-> [];
is_in_col(Grid, {Row, Col}, Val, I) -> 
    [lists:nth(Col,lists:nth(I, Grid))|is_in_col(Grid, {Row,Col}, Val, I+1)].

is_in_box(Grid, {Row, Col}, Val) -> lists:member(Val, is_in_box(Grid, {Row,Col}, Val, {1,1})).
is_in_box(Grid, {Row,Col}, Val, {BoxRow,BoxCol}) when BoxRow > 3 -> [];
is_in_box(Grid, {Row,Col}, Val, {BoxRow,BoxCol}) when BoxCol > 3 -> is_in_box(Grid, {Row,Col}, Val, {BoxRow+1,1});
is_in_box(Grid, {Row,Col}, Val, {BoxRow,BoxCol}) ->
    Value = lists:nth(BoxCol+(((Col-1) div 3) * 3),lists:nth(BoxRow+(((Row-1) div 3)*3),Grid)),
    [Value|is_in_box(Grid, {Row,Col}, Val, {BoxRow,BoxCol+1})].
%% AI Generated
valAt(Grid, {Row, Col}) ->
    CurrentRow = lists:nth(Row, Grid),
    %%io:format("Value at cell is ~p~n\n", [lists:nth(Col, CurrentRow)]),
    lists:nth(Col, CurrentRow).
replace_val(Grid, {Target_Row, Target_Col}, Num) ->
    map_with_index(
        fun(Row, RowIdx) ->
            if RowIdx =:= Target_Row ->
                map_with_index(
                    fun(Val, ColIdx) ->
                        if ColIdx =:= Target_Col -> Num;
                           true -> Val
                        end
                    end,
                    Row
                );
               true -> Row
            end
        end,
        Grid
    ).

map_with_index(Fun, List) ->
    map_with_index(Fun, List, 1).

map_with_index(_Fun, [], _Idx) -> [];
map_with_index(Fun, [H|T], Idx) ->
    [Fun(H, Idx) | map_with_index(Fun, T, Idx + 1)].