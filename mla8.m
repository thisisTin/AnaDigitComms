clear all
clc
close all
fs=2000;

bps = 3;  % Bit trên mỗi ký hiệu 
M = 2^bps; % Thứ tự điều chế  
dpskmod = comm.DPSKModulator(M, pi/4, BitInput=true);
dpskdemod = comm.DPSKDemodulator(M, pi/4, BitOutput=true);
errorRate = comm.ErrorRate(ComputationDelay=1);
numframes = 100; % Số khung
spf = 150;       % Số ký hiệu trên mỗi khung

EbN0dB = -2:2:12; % Dải giá trị Eb/N0 (dB)
ber = zeros(1, length(EbN0dB)); % Mảng chứa tỷ lệ lỗi bit

% Vẽ đường tỷ lệ lỗi bit theo Eb/N0
for i = 1:length(EbN0dB)
    errorRate = comm.ErrorRate(ComputationDelay=1);
    snr = convertSNR(EbN0dB(i), "ebno", "snr", BitsPerSymbol=bps);
    
    for counter = 1:numframes
        txData = randi([0 1], spf, 1);
        modSig = dpskmod(txData);
        
        % **1. Biểu đồ chòm sao của tín hiệu điều chế tại máy phát**
        if counter == 1 && i == 1
            figure;
            scatter(real(modSig), imag(modSig), '.');
            xlabel('Thành phần thực');
            ylabel('Thành phần ảo');
            title('Biểu đồ chòm sao của tín hiệu điều chế tại máy phát');
            axis equal;
            grid on;
        end
        
        rxSig = awgn(modSig, snr, 'measured');
        rxData = dpskdemod(rxSig);
        errorStats = errorRate(txData, rxData);
        
        % Lấy mẫu đúng của tín hiệu giải điều chế
        rxData = rxData(1:spf); % Chỉ lấy spf mẫu
    end
    
    ber(i) = errorStats(1);
end

% **2. Vẽ đường tỷ lệ lỗi bit theo Eb/N0**
figure;
plot(EbN0dB, ber, '-o');
xlabel('Eb/N0 (dB)');
ylabel('Tỷ lệ lỗi bit (BER)');
title('Đường tỷ lệ lỗi bit theo Eb/N0');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mau=50;
mau1=200;
%tin hieu nhan duoc sau dieu che khi FFT
x1=fft(rxData,mau);
x1=fftshift(x1);
f1=-fs/2:fs/mau:fs/2-fs/mau;
%tin hieu nhan duoc khi FFT
n_de=0:1/fs:(1/fs)*(mau-1);
x_de=rxSig(1:1/fs:length(n_de));
x2=fft(x_de,mau);
x2=fftshift(x2);
%tin hieu song mang khi FFT
fc=500;
nc=0:1/fs:(1/fs)*(mau1-1);
c_n=cos(2*pi*fc*nc);
x3=fft(c_n,mau1);
x3=fftshift(x3);
f2=-fs/2:fs/mau1:fs/2-fs/mau1;
%tin hieu dieu che
n_dc=0:1/fs:(1/fs)*(mau-1);
dieuche=modSig(1:1/fs:length(n_dc));
x4=fft(dieuche,mau);
x4=fftshift(x4);
figure;
%ve pho tin hieu nhan duoc sau khi giai dieu che
subplot(4,1,4);
stem(f1,abs(x1));
grid on;
xlabel('f');
ylabel('X1');
title('Spectrum of Data Signal after demodulation');
ylim([0 100]);
%ve pho tin hieu nhan duoc
subplot(4,1,3);
stem(f1,abs(x2));
grid on;
xlabel('f');
ylabel('X2');
title('Spectrum of Data Signal');
ylim([0 100]);
%ve pho cua tin hieu song mang
subplot(4,1,1);
stem(f2,abs(x3));
xlabel('f');
ylabel('X3');
title('spectrum of carrier');
grid on;
ylim([0 100]);
%ve pho cua tin hieu dieu che
subplot(4,1,2);
stem(f1,abs(x4));
xlabel('f');
ylabel('X4');
title('Pho cua tin hieu dieu che');
grid on;
ylim([0 100]);



