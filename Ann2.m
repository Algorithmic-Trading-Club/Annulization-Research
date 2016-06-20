%% Number of time periods (value of yr/t)
n = 200;

%% Generate P and B sequence for n time intervals
P = rand(1,n);
B = rand(1,n);
D = P - B;

%% Set up and solve Andre's equation
syms A;
LHS = prod(P)^n;
RHS = prod(A+B.^n);
 
eqn = LHS == RHS;
solns = vpasolve(eqn, A);
solns

%%  Reasonability checks on solutions.
%   Check 1: Discard complex solutions
A_vals = solns(solns == real(solns));
A_vals

%   Check 2: Discard unbounded solutions
%{
    THIS SEEMS TO DISCARD SOLUTIONS IF min(D) = max(D)???
    TRY WITH
    P = [1, 1, 1, 1, 1];
    B = [2, 2, 2, 2, 2];
    D = P - B;
%}
indices = find(A_vals < min(D) | A_vals > max(D));
A_vals(indices) = [];
A_vals

%   Check 3: Discard non-monotonic solutions
deriv = diff(RHS);
for i = length(A_vals):-1:1
    A = A_vals(i);
    if subs(deriv) < 0
        A_vals(i) = [];
    end
end
A_vals

%   Check 4: Pick solution closest to naive difference
%{
This check fails when values of A are sufficiently close to zero.
However, if they are sufficiently close to zero, they may be considered
exactly zero for practical purposes.
%}
naive = prod(P)^(1/length(P)) - prod(B)^(1/length(B));
[opt, index] = min(abs(A_vals - naive));
A_vals = A_vals(index);
A_vals
