function [f_axis,spectrum] = EEGspectrum(signal,fs)
lensignal = length(signal);
signalfft = abs(fft(signal));
signalfft = abs(signalfft) / lensignal;
num_spectrum = fix(lensignal / 2);
spectrum = signalfft(:, 1:num_spectrum);
f_axis = (0:num_spectrum-1) * fs / lensignal;
end
