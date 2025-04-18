% 信号の読み込み
filename = '美声.wav';
[audioData, Fs] = audioread(filename);
%sound(audioData, samplingRate);

% パラメータ設定
windowLength = 2 ^ 9;               %窓長
shiftWidth = windowLength / 2;      %シフト幅

% 信号のはじめをゼロパティング
temp = zeros(shiftWidth, 1);
audioData = [temp; audioData];

% 信号の長さを取得
sigLen = length(audioData);

% フレーム数を計算
numFrames = floor(sigLen / shiftWidth);

% 複素スペクトルログラムを入れる変数
S = zeros(windowLength, numFrames);

% フレームの抽出
for i = 1:numFrames
    startIdx = (i - 1) * shiftWidth + 1;
    endIdx = startIdx + windowLength -1;
    
    if endIdx > sigLen
        S(:, i) = [audioData(startIdx:sigLen); zeros(endIdx - sigLen, 1)];
    else
        S(:, i) = audioData(startIdx:endIdx);
    end
end

% 窓関数（ハン窓）の実装
n = 0:windowLength-1;
hanWin = 0.5 - 0.5 * cos((2 * pi * n) / (windowLength -1));
hanWin = hanWin(:);

% ハン窓を信号に乗算してfftして変数に格納
for i = 1:size(S,2)
    S(:, i) = S(:, i) .* hanWin;
    S(:, i) = fft(S(:, i));
end


