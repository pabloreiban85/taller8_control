

% Parametros del motor DC
Ra = 0.635;
La = 0.0883;
Ki = 9.43e-3;
Kb = 1010;
Jm = 330;
Bm = 1e-3;

% Funcion de transferencia del motor
num = Ki/(La*Jm);
den = [1 (Bm/Jm + Ra/La) (Ra*Bm + Ki*Kb)/(La*Jm)];
G = tf(num, den);

% Parametros de diseno
Mp = 0.1;
tss = 1;

% Calculo de zeta y wn
zeta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);
wn = 4 / (zeta * tss);

% Polos deseados
polos_deseados = roots([1 2*zeta*wn wn^2]);

% Lugar geometrico de las raices
figure;
rlocus(G)
hold on;
grid on;

% Polos deseados
plot(real(polos_deseados), imag(polos_deseados), 'rx', ...
     'MarkerSize', 10, 'LineWidth', 2);

% Ajuste manual de ejes
axis([-10 2 -8 8])   % [xmin xmax ymin ymax]

