% In màn hình
print_list([]).
print_list([Matrix|List]):- print_list(List),print_board(Matrix).
print_path(X,path):- print_board(X),nl,write(finish).
print_path(X,Direction:Path):-  next_to(X,Y,Direction), print_board(X),print_path(Y,Path).
print_board([X1,X2,X3,X4,X5,X6,X7,X8,X9]):-  nl,
    write(X1), write('.....'),write(X2),write('.....'),write(X3),nl,
    write(X4), write('.....'),write(X5),write('.....'),write(X6),nl,
    write(X7), write('.....'),write(X8),write('.....'),write(X9),nl.

% Quan hệ qua lại lên xuống, tìm vị trí số 0.
goal([1,2,3,8,0,4,7,6,5]).
check_empty([]).
next_to([X1,X2,X3,0,X5,X6,X7,X8,X9],[0,X2,X3,X1,X5,X6,X7,X8,X9],up).
next_to([X1,X2,X3,X4,0,X6,X7,X8,X9],[X1,0,X3,X4,X2,X6,X7,X8,X9],up).
next_to([X1,X2,X3,X4,X5,0,X7,X8,X9],[X1,X2,0,X4,X5,X3,X7,X8,X9],up).
next_to([X1,X2,X3,X4,X5,X6,0,X8,X9],[X1,X2,X3,0,X5,X6,X4,X8,X9],up).
next_to([X1,X2,X3,X4,X5,X6,X7,0,X9],[X1,X2,X3,X4,0,X6,X7,X5,X9],up).
next_to([X1,X2,X3,X4,X5,X6,X7,X8,0],[X1,X2,X3,X4,X5,0,X7,X8,X6],up).
next_to(M1,M2,down):- next_to(M2,M1,up).

next_to([X1,0,X3,X4,X5,X6,X7,X8,X9],[0,X1,X3,X4,X5,X6,X7,X8,X9],left).
next_to([X1,X2,0,X4,X5,X6,X7,X8,X9],[X1,0,X2,X4,X5,X6,X7,X8,X9],left).
next_to([X1,X2,X3,X4,0,X6,X7,X8,X9],[X1,X2,X3,0,X4,X6,X7,X8,X9],left).
next_to([X1,X2,X3,X4,X5,0,X7,X8,X9],[X1,X2,X3,X4,0,X5,X7,X8,X9],left).
next_to([X1,X2,X3,X4,X5,X6,X7,0,X9],[X1,X2,X3,X4,X5,X6,0,X7,X9],left).
next_to([X1,X2,X3,X4,X5,X6,X7,X8,0],[X1,X2,X3,X4,X5,X6,X7,0,X8],left).
next_to(M1,M2,right):- next_to(M2,M1,left).
get_next_to(Matrix,Direction,List,[NextTo|List]):- next_to(Matrix,NextTo,Direction).
get_next_to(Matrix,up,List,List):- blank_position(Matrix,B),B<4.
get_next_to(Matrix,down,List,List):- blank_position(Matrix,B),B>6.
get_next_to(Matrix,left,List,List):- blank_position(Matrix,B),Bb is B-1,Bb mod 3=:=0.
get_next_to(Matrix,right,List,List):- blank_position(Matrix,B),Bb is B-1,Bb mod 3=:=2.
blank_position([0|_],1).
blank_position([X|P],N+1):- X \=0,blank_position(P,N).

% Tính G, H, F của 1 State.
distance_magantta(X1,X2,H):- Col1 is (X1-1) mod 3, Col2 is (X2-1) mod 3, Row1 is (X1-1)//3,
    Row2 is (X2-1)//3, abs(Row1-Row2,Row),abs(Col1-Col2,Col),H is Row+Col.
calculate_magantta([],[],0).
calculate_magantta([X1|A1],[X2|A2],C):- calculate_magantta(A1,A2,H),distance_magantta(X1,X2,D),C is H+D.
get_h(State,H):- goal(G),get_state(State,Arr,_,_),calculate_magantta(Arr,G,H).
get_f(State,F):- get_g(State,G),get_h(State,H),F is G+H.
get_g(State,G):- get_state(State,_,G,_).

% Thêm item vào Open và Close.
add_and_sort_at(Child,[],[Child]).
add_and_sort_at(Child,[Head|Children],[Head|Sorted]):-get_g(Head,G_head),
    get_g(Child,G_child),G_head<G_child,add_and_sort_at(Child,Children,Sorted).
add_and_sort_at(Child,[Head|Children],[Child|Sorted]):-get_g(Head,G_head),
    get_g(Child,G_child),G_head>=G_child,add_and_sort_at(Head,Children,Sorted).

add_open([],Open,Open).
add_open([Child|Children],Open,Sorted):-
    add_open(Children,Open,New_open),add_and_sort_at(Child,New_open,Sorted).
add_close(Ele,Close,[Ele|Close]).

% Tính các trạng thái liền kề
children(Matrix,NewList):- get_next_to(Matrix,up,[],N1),get_next_to(Matrix,down,N1,N2),
    get_next_to(Matrix,left,N2,N3), get_next_to(Matrix,right,N3,NewList).
in_open(Child,[Child|_]).
in_open(Child,[_,Open]):- in_open(Child,Open).
children_short([],_,[]).
children_short([Child|Children],Open,Short_Ch):- in_open(Child,Open),
        children_short(Children,Open,Short_Ch).
children_short([Child|Children],Open,[Child|Short_Ch]):- \+ in_open(Child,Open),
    children_short(Children,Open,Short_Ch).
children_state(State,Children_s):-  get_state(State,Arr,_,_), children(Arr,Ch),
    to_state(State,Ch,Children_s).
adjacentStates(State,OpenQueue,Short_Adjacents):-children_state(State,AdjacentStates ),children_short(AdjacentStates ,OpenQueue,Short_Adjacents).
% Các hàm cơ bản
get_head([A|B],A,B).
get_state(s(Arr,G,Path),Arr,G,Path).
to_state(_,[],[]).
to_state(Origin_state,[X|Ch],[s(X,N_new,Direction:Path)|Children]):- to_state(Origin_state,Ch,Children),
    get_state(Origin_state,A,Num,Path),next_to(X,A,Direction),N_new is 1+Num.

% Thuật toán chạy AT để chạy hồi quy
at(Open,_,_):- get_head(Open,Last,_),get_state(Last,Arr,_,Path),
    goal(Arr),write(Path),print_path(Arr,Path),!.
at(Open,Close,Loop):- get_head(Open,Head,Body),
    get_state(Head,Arrow,_,_), member(Arrow,Close),at(Body,Close,Loop).
at(OpenQueue,Close,Loop):- nl,write('second_door-----'), write(Loop),write('-----'),
    get_head(OpenQueue,Current_State,QueueBody),
    get_state(Current_State,Current_Array,_,_),
   write('current State'),write(Current_State),
    adjacentStates(Current_State,OpenQueue,Short_Adjacents),
    add_open(Short_Adjacents,QueueBody,NewOpen),add_close(Current_Array,Close,New_close),NewLoop is Loop+1,
    at(NewOpen,New_close,NewLoop).

% Chọn play(1). đến play(6) để chạy trò chơi.
game(1,[2,8,3,1,6,4,7,0,5]).
game(2,[2,8,1,0,4,3,7,6,5]).
start(State):- at([s(State,0,path)],[],0).
play(N):- game(N,State),start(State).
