n = 100;
N = 1;

Error = zeros(1,N);
Corr = zeros(1,N);

for i = 1:N
    P = 3*rand(1, n);
    B = 3*rand(1, n);
    C = cov(P, B)/(std(P)*std(B));
    Corr(1, i) = C(1, 2);
    Error(1, i) = prod(P-B)^n - (prod(P)^n -prod(B)^n);
end

scatter(Corr, Error)