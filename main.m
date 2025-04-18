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

% 短時間信号を格納する行列を初期化
frames = zeros(windowLength, numFrames);

% フレームの抽出
for i = 1:numFrames
    startIdx = (i - 1) * shiftWidth + 1;
    endIdx = startIdx + windowLength -1;
    
    if endIdx > sigLen
        frames(:, i) = [audioData(startIdx:sigLen); zeros(endIdx - sigLen, 1)];
    else
        frames(:, i) = audioData(startIdx:endIdx);
    end
end

%disp(['分割されたフレーム数', num2str(numFrames)]);
%disp(['各フレームの長さ', num2str(size(frames, 1)), 'サンプル']);

% 窓関数（ハン窓）の実装
n = 0:windowLength-1;
hanWin = 0.5 - 0.5 * cos((2 * pi * n) / (windowLength -1));
hanWin = hanWin(:);

% ハン窓を信号に乗算
windowedFrames = zeros(size(frames));
for i = 1:size(frames,2)
    windowedFrames(:, i) = frames(:, i) .* hanWin;
end

