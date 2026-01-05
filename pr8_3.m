
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

pc
zc


theta1_deg
theta4_deg
% Compensador sin Kc
Cs = tf([1 -zc],[1 -pc]);


%====================================================
figure;
rlocus(Cs*G)
hold on;
grid on;
axis([-10 2 -8 8])
plot(real(polos_deseados), imag(polos_deseados), 'rx', ...
     'MarkerSize', 10, 'LineWidth', 2);

%====================================================

figure;
hold on;
grid on;

% Polos del sistema original
plot(real(polos), imag(polos), 'bx', ...
     'MarkerSize', 10, 'LineWidth', 2);

% Polos deseados
plot(real(polos_deseados), imag(polos_deseados), 'rx', ...
     'MarkerSize', 10, 'LineWidth', 2);

% Cero del compensador
plot(real(zc), 0, 'go', ...
     'MarkerSize', 10, 'LineWidth', 2);

% Polo del compensador
plot(real(pc), 0, 'gx', ...
     'MarkerSize', 10, 'LineWidth', 2);

axis([-10 2 -8 8])



%Polos y ceros del compensador y proceso a lazo abierto, con los polos deseados.
