import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# =========================
# Limpieza (equivalente a clear; clc; close all;)
# =========================
plt.close('all')

# =========================
# Parámetros del sistema
# =========================
R = 22
L = 500e-6
C = 220e-6

# =========================
# Función de transferencia
# =========================
num = [0, 1/(L*C)]
den = [1, R/L, 1/(L*C)]

Gs = ctrl.TransferFunction(num, den)

Hs = 1

# =========================
# Lazo cerrado
# =========================
tf_cl = ctrl.feedback(Gs, Hs)

# =========================
# Denominador y polos
# =========================
den_cl = [1, 44000, 1.818e7]
polos = np.roots(den_cl)

# =========================
# Parámetros de diseño
# =========================
Mp = 0.25
tss = 50e-3

Z = np.log(1/Mp) / np.sqrt(np.pi**2 + (np.log(1/Mp))**2)
wn = 4 / (tss * Z)

# Ecuación característica deseada
ec_carac = np.roots([1, 2*Z*wn, wn**2])

# =========================
# Cálculo de ángulos
# =========================
m = np.imag(ec_carac[0]) / (np.real(ec_carac[0]) - np.real(polos[1]))

theta1 = np.pi - np.arctan(m)
theta4 = np.pi - theta1

x = np.imag(ec_carac[0]) / np.tan(theta4)

# =========================
# Polo y cero del compensador
# =========================
pc = np.real(ec_carac[0]) - x
zc = polos[0]

# =========================
# Cálculo de Kc (condición de magnitud)
# =========================
Cs = ctrl.TransferFunction([1, -zc], [1, -pc])
CGHs = Hs * Cs * Gs

s_val = ec_carac[0]
Kc = 1 / abs(ctrl.evalfr(CGHs, s_val))

# =========================
# Compensador con ganancia
# =========================
GCs = Kc * Cs

# =========================
# Sistema compensado
# =========================
Comp1 = GCs * Gs
Comp2 = ctrl.feedback(Comp1, Hs)

# =========================
# Gráficas
# =========================

# Respuesta al escalón
plt.figure()
t, y = ctrl.step_response(Comp2)
plt.plot(t, y)
plt.grid()
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Respuesta al escalón del sistema compensado')

# Polos y ceros
plt.figure()
ctrl.pzmap(Comp2, plot=True, grid=True)

plt.show()
