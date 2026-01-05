
%parametros del motor
Ra = 0.635;
La = 0.0883;
Ki = 9.43e-3;
Kb = 1010;
Jm = 330;
Bm = 1e-3;

% Funcion de Transferencia:
num = Ki/(La*Jm);
den = [1 (Bm/Jm + Ra/La) (Ra*Bm + Ki*Kb)/(La*Jm)];
G = tf(num, den);

polos = pole(G);



%Parametros de diseño
Mp = 0.1;
tss = 1;

zeta = log(1/Mp)/sqrt(pi^2 + (log(1/Mp))^2);
wn = 4/(zeta*tss);

% Polos deseados
polos_deseados = roots([1 2*zeta*wn wn^2]);



% Calculo del compensador (metodo del angulo)
m = imag(polos_deseados(1)) / (real(polos_deseados(1)) - real(polos(2)));

theta1 = pi + atan(m);
theta4 = pi - theta1;

theta1_deg = rad2deg(theta1);
theta4_deg = rad2deg(theta4);

x = imag(polos_deseados(1)) / tan(theta4);



pc = real(polos_deseados(1)) - x;   % polo del compensador
zc = polos(1);          % cero del compensador


% Compensador sin Kc
Cs = tf([1 -zc],[1 -pc]);



%====Calcular Kc==============
Hs = 1010;

% Sistema a lazo abierto SIN Kc = Cs * G * Hs

% Ganancia del compensador
Kc = 1 / abs(evalfr(Cs * G * Hs, polos_deseados(1)));

Kc




