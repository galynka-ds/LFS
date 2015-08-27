fstar = @(x) min(x, 1-x);

% plot(0:0.001:1, fstar(0:0.001:1))

K = @(x1, x2) (1 + min(x1, x2));
table = [];
for N = [256, 384, 512, 768, 1024, 2048, 4096, 8192] %, 512, 1024, 2048, 4096, 8192]

    fprintf('\nN = %f, ', N)
XXtest = datasample(rand(6 * N, 1), 2 * N, 'Replace',false);
X = XXtest(1:N);%datasample(rand(4 * N, 1), N, 'Replace',false);
Ystar = fstar(X);
Y = Ystar + sqrt(0.02) * randn(size(X));
Xtest = XXtest(N+1 : end);%datasample(rand(4 * N, 1), N, 'Replace',false);
Ytest = fstar(Xtest);
clear XXtest;
% hold on
%plot(X, Y, 'r.')


for m = [4, 16, 64] % 1
    funtable = zeros(length(Y), m);
    funtabletest = zeros(length(Ytest), m);
    fprintf('\nm = %f, ', m)
   Xr = reshape(X, [N / m, m]);
   Yr = reshape(Y, [N / m, m]);
   for i = 1:m
       c = construct_f( Xr(:, i), Yr(:, i), power(N / m, -2/3), K); %power(N, -2/3)
       funtable(:, i) = predict(Xr(:, i), X, c, K);
       funtabletest(:, i) = predict(Xr(:, i), Xtest, c, K); %power(N, -2/3)
       %plot(Xr(:, i), Yr(:, i), 'd');
   end
   Ypred = sum(funtable, 2) / m;
   Ypredtest = sum(funtabletest, 2) / m;
   Grammatrix = zeros(m, m);
   g = zeros(m, 1);
   for i = 1:m
       for j = 1:m
           Grammatrix(i, j) = dot(funtable(:, i), funtable(:, j));
       end
       g(i) = dot(funtable(:, i), Y);
   end
   Yaggrpred = funtable * (Grammatrix \ g);
   Yaggrpredtest = funtabletest * (Grammatrix \ g);
   %plot(X, Ypred, 'd')
   table(1:6, end + 1) = [m, N, immse(Ystar, Ypred), immse(Ytest, Ypredtest), immse(Ystar, Yaggrpred), immse(Ytest, Yaggrpredtest)]; % norm(fstar(X) - Ypred).^2 / length(Y)
end
end
fprintf('\n');
figure;
for m = [4, 16, 64] %1, 
loglog(table(2, find(table(1, :) == m)), table(3, find(table(1, :) == m)), 's-')
hold on
loglog(table(2, find(table(1, :) == m)), table(5, find(table(1, :) == m)), 'd--')
hold on
end
legend('m = 4', 'm = 4, aggr', 'm = 16', 'm = 16, aggr', 'm = 64', 'm = 64, aggr')
% 'm = 1', 'm = 1, aggr', 
grid on

figure;
for m = [4, 16, 64] % 1, 
loglog(table(2, find(table(1, :) == m)), table(4, find(table(1, :) == m)), 's-')
hold on
loglog(table(2, find(table(1, :) == m)), table(6, find(table(1, :) == m)), 'd--')
hold on
end
legend('m = 4', 'm = 4, aggr', 'm = 16', 'm = 16, aggr', 'm = 64', 'm = 64, aggr')
% 'Test: m = 1', 'm = 1, aggr', 
grid on