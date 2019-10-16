% BPF Hamming 
clc; 
close all;

f1 = input('frequency f1 :');
f2 = input('frequency f1 :');
fc1 = input('Lower Cutoff frequency fc1 :');
fc2 = input('Upper Cutoff frequency fc2 :');
N = input('Order of the Filter :');
fs = 5* max(f1,f2);
wc1 = 2* pi* fc1 / fs;
wc2 = 2* pi* fc2 / fs;
T = (N-1)/2;
hd = zeros(1,N);
wd = zeros(1,N);
for k =1:N
    wd(k) = 0.54 - 0.46* cos(2*pi*k/(N-1));
    if k==T
        hd(k)=(wc2-wc1)/pi;
    else
        hd(k)= ( sin(wc2*(k-T)) - sin(wc1*(k-T) ) )/ (pi*(k-T)) ;
    end
end


h_bpf = hd.*wd;
disp(['Filter Coefficients h' num2str(h_bpf)]);

t = 0:1/fs: 1 -1/fs;
x = sin(2*pi*f1*t)+cos(2*pi*f2*t);
xk = abs(fft(x));

filter_out = conv(x,h_bpf);
filter_out_k = abs(fft(filter_out));


figure(1);
subplot(4,1,1);
plot((1:200),x(1:200));
title('Input Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
plot(xk);
title('fft of Input Signal');
xlabel('frequency');
ylabel('Amplitude');
grid on;

subplot(4,1,3);
plot((1:200),filter_out(1:200));
title('Filtered Signal (Hamming BPF)');
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(4,1,4);
plot(filter_out_k);
title('fft of filtered Signal');
xlabel('Frequency');
ylabel('Amplitude');
grid on;

figure(2);
freqz(h_bpf);
title({['magnitude,' 'and', 'Phase plots'];['Hamming BPF', '(Without builtin Function)']})

figure(3);
m = fir1(N,[2*fc1/fs 2*fc2/fs],'bandpass',hamming(N+1));
freqz(m);
title({['magnitude,' 'and', 'Phase plots'];['Hamming BPF', '( builtin Function)']})

