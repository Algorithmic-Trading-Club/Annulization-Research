%% Define n (value of yr/T)
n = 12;

%% Define D (NB: P and B are return factors)
syms e;
D = [];
for i = 1:n
    D = [D, e];
end

%% Compute Ann(P-B) = Ann(D)
ann_diff = prod(D)^n;
vpa(limit(ann_diff))

%% Compute Ann(P)-Ann(B)
B = rand(1, n);
P = D + B;
diff_ann = prod(P)^n - prod(B)^n;
vpa(limit(diff_ann))

%% Graph error vs e
E = [];
Error = [];
xmax = 0.001;
for i = 1:n
    E = [E, xmax*i/n];
    Error = [Error, subs(ann_diff, e, xmax*i/n) - subs(diff_ann, e, xmax*i/n)];
end
scatter(E, Error)
