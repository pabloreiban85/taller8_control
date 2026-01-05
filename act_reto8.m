clear; clc; close all;

% Parámetros del sistema
R = 22;
L = 500e-6;
C = 220e-6;

% Función de transferencia
num = [0, 1/(L*C)];
den = [1, R/L, 1/(L*C)];

% Función en lazo abierto
Gs = tf(num, den);

Hs = 1;

% Función en lazo cerrado
tf_cl = feedback(Gs, Hs);

% Denominador y polos del lazo cerrado
den_cl = [1, 44000, 1.818e7];
polos = roots(den_cl);

% Parámetros de diseño
Mp = 0.25;
tss = 50e-3;

Z = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);
wn = 4 / (tss * Z);

% Ecuación característica deseada
ec_carac = roots([1 2*Z*wn wn^2]);

% Cálculo de ángulos
m = imag(ec_carac(1)) / ...
    (real(ec_carac(1)) - real(polos(2)));

theta1 = pi - atan(m);
theta4 = pi - theta1;

x = imag(ec_carac(1)) / tan(theta4);

% Nuevo polo y cero del compensador
pc = real(ec_carac(1)) - x;
zc = polos(1);

% Cálculo de Kc por condición de magnitud
Cs = tf([1 -zc], [1 -pc]);
CGHs = Hs * Cs * Gs;

s_val = ec_carac(1);
Kc = 1 / abs(evalfr(CGHs, s_val));

% Compensador con ganancia
GCs = Kc * Cs;

% Sistema compensado
Comp1 = series(GCs, Gs);
Comp2 = feedback(Comp1, Hs);

% Respuesta al escalón del sistema compensado
figure;
step(Comp2)
grid on
title('Respuesta al escalón del sistema compensado')

% Polos y ceros del sistema compensado
figure;
pzmap(Comp2)
grid on
