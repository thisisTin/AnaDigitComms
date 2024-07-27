clear all
close all
clc

M = 16
bps = 4               % bit per symbol
EbN0 = 0:10                 % Ty le nang luong tren bit
SNR = EbN0 + 10*log10(bps)  % Ty le nhieu (dB)
ber = zeros(size(SNR))      % Tao mang trong cho ty le loi bit
N = 1024                    % So bit can truyen
data = randi([0 M-1],N,1)   % Tao du lieu ngau nhien

% Song mang
Fc = 1000                    % Tan so song mang
t = (0:N-1)/Fc             % Thoi gia
xn = cos(2*pi*Fc*t)       % Song mang

% Dieu che DPSK tai may phat
modSig = dpskmod(data,M)


for i = 1:length(SNR)
 addAwgn = awgn(modSig, SNR(i), 'measured'); % Them nhieu trang Gaussian
 rxSig = awgn(modSig, EbN0(i) + 10*log10(bps), 'measured');
 demodSig = dpskdemod(addAwgn, M);           % Giai dieu che DPSK
 ber(i) = biterr(data, demodSig);            % tinh ty le loi bit
end

figure ;
semilogy(EbN0,ber,'o-')
grid on
xlabel('Eb/N0 (dB)')
title('bit error rate')

scatterplot(modSig,[],[],'*b')

figure ;
pwelch(xn)                               % Pho cua song mang
title('Spectrum of carrier signal')

figure;
pwelch(modSig)                           % Pho cua tin hieu dieu che tai may phat
title('Spectrum of modulated signal')

figure;
pwelch(rxSig);
title('Spectrum of received signal');

figure;
pwelch(demodSig)                         % Pho cua tin hieu giai dieu che tai may thu
title('Spectrum of demodulated signal')