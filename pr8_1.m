%parametros del motor
Ra = 0.635;
La = 0.0883;
Ki = 9.43e-3;
Kb = 1010;
Jm = 330;
Bm = 1e-3;

% Funcion de Transferencia:
num = Ki/(La*Jm);
den = [1, (Bm/Jm + Ra/La), (Ra*Bm + Ki*Kb)/(La*Jm)];
G = tf(num, den);

%polos del sistema
roots(den)

%Step
figure;
step(G)

%Rlocus
figure;
rlocus(G)



