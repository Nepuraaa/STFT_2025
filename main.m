% 信号の読み込み
filename = '美声.wav';
[audioData, Fs] = audioread(filename);

% パラメータ設定
windowLength = 2^9;
shiftWidth = windowLength / 2;

% 関数に引数（音信号，音信号のサンプリング周波数，窓長）を渡す
% 戻り値はS（複素数値）
S = STFT(audioData, Fs, windowLength, shiftWidth);
