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
next_to([X1,0,X3,X4,X5,X6,X7,X8,X9],[0,X1,X3,X4,X5,X6,X7,X8,X9],left).
next_to([X1,X2,0,X4,X5,X6,X7,X8,X9],[X1,0,X2,X4,X5,X6,X7,X8,X9],left).
next_to([X1,X2,X3,X4,0,X6,X7,X8,X9],[X1,X2,X3,0,X4,X6,X7,X8,X9],left).
next_to([X1,X2,X3,X4,X5,0,X7,X8,X9],[X1,X2,X3,X4,0,X5,X7,X8,X9],left).
next_to([X1,X2,X3,X4,X5,X6,X7,0,X9],[X1,X2,X3,X4,X5,X6,0,X7,X9],left).
next_to([X1,X2,X3,X4,X5,X6,X7,X8,0],[X1,X2,X3,X4,X5,X6,X7,0,X8],left).
next_to(M1,M2,down):- next_to(M2,M1,up).
next_to(M1,M2,right):- next_to(M2,M1,left).
write_out(Trace,right):- nl,nl,write(Trace).
write_out(Trace,D):- D \= right.

dfs(X,P,[X|P],_):- goal(X), !.
dfs(X,P,Path,Trace):- next_to(X,Y,Direction), Y\= X, write_out(Trace,Direction), 
\+member(Y,P), dfs(Y,[X|P],Path,Trace-Direction).
