% Параметры OFDM

N = 1; % Количество поднесущих
cp_len = 16; % Длина циклического префикса
num_symbols = 10; % Количество OFDM символов

% Параметры BPSK
f_bpsk = 10; % Частота несущей (Гц)
Fs = 100; % Частота дискретизации (Гц)
T = 1/Fs; % Период дискретизации
t = 0:T:1-T; % Временной вектор (1 секунда)

% Генерация случайных данных (BPSK модуляция)
data = randi([0 1], 1, N * num_symbols); % Биты 0 и 1

% Построение графиков
figure;

% График бинарных данных
subplot(4, 1, 1);
stem(data, 'LineWidth', 2);
title('Бинарные данные');
xlabel('Биты');
ylabel('Значение');
ylim([-0.5 1.5]);
grid on;


bpsk_symbols = exp(1j * (pi * data)); % BPSK: 0 -> 1, 1 -> -1

% Преобразование данных в матрицу поднесущих
bpsk_symbols = reshape(bpsk_symbols, N, num_symbols);

% Обратное быстрое преобразование Фурье (IFFT)
ofdm_symbols = ifft(bpsk_symbols);

% Добавление циклического префикса
ofdm_symbols_with_cp = [ofdm_symbols(end-cp_len+1:end, :); ofdm_symbols];

% Преобразование матрицы в один временной ряд
ofdm_signal = ofdm_symbols_with_cp(:).';

% Построение графика выходного сигнала
t_ofdm = 0:length(ofdm_signal)-1;
figure;
plot(t_ofdm, real(ofdm_signal), 'b', t_ofdm, imag(ofdm_signal), 'r');
xlabel('Время');
ylabel('Амплитуда');
title('Выходной сигнал OFDM передатчика');
legend('Реальная часть', 'Мнимая часть');
grid on;

% Построение спектра передаваемого сигнала
Fs = 1000; % Частота дискретизации (предположим)
L = length(ofdm_signal); % Длина сигнала
f = Fs * (-L/2:L/2-1) / L; % Вектор частот
spectrum = fftshift(abs(fft(ofdm_signal))); % Спектр сигнала

figure;
plot(f, spectrum);
xlabel('Частота (Гц)');
ylabel('Амплитуда');
title('Спектр передаваемого OFDM сигнала');
grid on;
