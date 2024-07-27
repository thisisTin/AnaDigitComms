clc
clear all
% Khởi tạo các tham số
M = 4; % Số lượng điểm chòm sao
bitsPerSymbol = log2(M);
EbNo = 0:10; % Tỷ lệ năng lượng bit trên năng lượng nhiễu
numBits = 100; % Số lượng bit để mô phỏng

% Tạo tín hiệu nguồn
data = randi([0 M-1], numBits, 1);

% Điều chế DPSK
modSig = dpskmod(data, M);

% Tạo tín hiệu sóng mang
fc = 1000; % Tần số của sóng mang
t = (0:length(modSig)-1)/fc; % Thời gian
carrier = cos(2*pi*fc*t.'); % Sóng mang

% Khởi tạo mảng để lưu tỷ lệ lỗi bit
%ber = zeros(size(EbNo));

% Mô phỏng kênh truyền nghiễu trắng và giải điều chế cho mỗi giá trị EbNo
for i = 1:length(EbNo)
    rxSig = awgn(modSig, EbNo(i) + 10*log10(bitsPerSymbol), 'measured');
    demodSig = dpskdemod(rxSig, M);
    [~, ber(i)] = biterr(data, demodSig);
end

% Vẽ biểu đồ chòm sao
figure;
scatterplot(modSig);
title('Biểu đồ chòm sao của tín hiệu điều chế');
axis('square');
grid on; 


% Vẽ phổ tín hiệu
figure;
subplot(2,2,1);
pwelch(modSig);
title('Spectrum of modulated signal');
subplot(2,2,2);
pwelch(carrier);
title('Spectrum of carrier signal');
subplot(2,2,3);
pwelch(rxSig);
title('Spectrum of received signal');
subplot(2,2,4);
pwelch(demodSig);
title('Spectrum of demodulated signal');



% Số lượng bit
M=4;
N = 10^6;
bitsPerSymbol = log2(M);
% Tạo dữ liệu ngẫu nhiên
data = randi([0 M-1], N, 1);

% Điều chế DPSK
modData = dpskmod(data, M);

% Mô phỏng kênh truyền nghiễu trắng
EbNo = 0:2:10;
snr = EbNo + 10*log10(bitsPerSymbol);
ber = zeros(size(snr));

for i = 1:length(snr)
    receivedSignal = awgn(modData, snr(i), 'measured');

    % Giải điều chế tại máy thu
    demodData = dpskdemod(receivedSignal, M);

    % Tính toán tỷ lệ lỗi bit
    [~, ber(i)] = biterr(data, demodData);
end

% Vẽ đường tỷ lệ lỗi bit theo Eb/N0
figure;
semilogy(EbNo, ber,'o-');
grid on;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('Bit error probability curve for 4-DPSK modulation');