%{
        Ann1 finds the average active return A for a given set of returns
    of portfolio and benchmark returns (P and B) a certain invariant time
    period.
        E.g. given the values of P and B for n years, Ann1 finds A as an
    annualized value. If P and B are given as monthly values, Ann1 finds A
    as a monthized value. Ann1 is incapable of finding an annualized A from
    monthly P and B, for example.
%}

%% Number of time periods (value of yr/t)
n = 20;

%%  Generate P and B sequence for n time periods
%   Note that neither P nor B can be negative: they are factors
P = 2*rand(1,n);
B = 2*rand(1,n);
D = P - B;

%{
P = 2*rand(1,5);
B = 2*rand(1,5);
D = P - B;

% 6 real solns
P = [0.3562, 0.7193, 0.1134, 1.0438, 0.6717, 0.3513];
B = [0.4179, 1.8103, 1.3508, 0.9369, 1.8243, 0.2080];
D = P - B;

% 5 real solns
P = [0.1685, 0.3278, 0.6484, 0.6035, 0.0234];
B = [1.0798, 0.1907, 0.2930, 1.2623, 1.7186];
D = P - B;

% 3 real solns
P = [1.7899, 0.1429, 0.4850, 0.1075, 0.8834];
B = [0.0266, 1.7944, 0.3933, 0.1867, 0.6147];
D = P - B;
%}
%%  Set up and solve Andre's equation.
LHS = 1;
RHS = 1;
syms A

for i = 1:length(P)
    LHS = LHS*P(1, i);
    RHS = RHS*(A+B(1, i));
end

eqn = LHS == RHS;
solns = vpasolve(eqn, A);
solns
%%  Reasonability checks on solutions.
%{
    1) Discard complex solutions
    2) Discard solutions that are larger/smaller than the extreme values
    3) Check that averages exhibit monotonicity
    4) Pick average that closest to the naive difference of annualizations
%}

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
    slope = subs(deriv);
    if slope < 0
        A_vals(i) = [];
    end
end
A_vals

%   Check 4: Pick solution closest to naive difference
AnnP = 1;
AnnB = 1;
for i = 1:length(P)
    AnnP = AnnP*P(1, i);
    AnnB = AnnB*B(1, i);
end
AnnP = (AnnP)^(1/length(P)) - 1;
AnnB = (AnnB)^(1/length(B)) - 1;
naive = AnnP - AnnB;
[opt, i] = min(abs(A_vals - naive));
A_vals = A_vals(i);
A_vals