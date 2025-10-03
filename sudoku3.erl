-module(sudoku3).
-export([solve3/1, remove/2]).

%%Should only solve a 3 by 3 grid
%% 
%% [ 1 2 4 ]
%% [ 5 7 6 ]
%% [ 3   8 ]
%% This should only take 2d lists
%% Puzzle = [[1,2,4],[5,7,6],[3,0,8]]
solve3(Puzzle) when is_list(Puzzle)->
    {[UnusedNum], [{EmptyRow, EmptyCol}]} = findVals({0,0}, Puzzle, [1,2,3,4,5,6,7,8,9], []),
    replace(UnusedNum, {EmptyRow, EmptyCol}, Puzzle).
findVals({Row, Col}, Board, UnusedNums, EmptyPos) when Row > 2 ->
    {UnusedNums, EmptyPos};
findVals({Row, Col}, Board, UnusedNums, EmptyPos) when Col > 2 ->
    findVals({Row + 1, 0}, Board, UnusedNums, EmptyPos);
findVals({Row,Col}, Board, UnusedNums, EmptyPos) ->
    Num = findValueofPos({Row,Col}, Board),
    if Num =/= 0 ->
        NewList = remove(Num, UnusedNums),
        NewEmptyList = EmptyPos;
       true ->
        NewList = UnusedNums,
        NewEmptyList = [{Row,Col}|EmptyPos]
    end,
    findVals({Row,Col+1}, Board, NewList,NewEmptyList).
%% Given a Position, returns value of the board there
findValueofPos({Row, Col}, Board) ->
    case lists:nth(Row + 1, Board) of
        RowList -> lists:nth(Col + 1, RowList)
    end.

%% Removes a Number from a list
remove(Num, List) ->
    lists:filter(fun(X) -> X =/= Num end, List).

%% Replace item at row and column pos with num
replace(Num, {RowPos, ColPos}, Board) ->
    map_with_index(
        fun(Row, RowIdx) ->
            if RowIdx =:= RowPos ->
                map_with_index(
                    fun(Val, ColIdx) ->
                        if ColIdx =:= ColPos -> Num;
                           true -> Val
                        end
                    end,
                    Row
                );
               true -> Row
            end
        end,
        Board
    ).

%% Helper: map with index for lists
map_with_index(Fun, List) ->
    map_with_index(Fun, List, 0).

map_with_index(_Fun, [], _Idx) -> [];
map_with_index(Fun, [H|T], Idx) ->
    [Fun(H, Idx) | map_with_index(Fun, T, Idx + 1)].