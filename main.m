% 信号の読み込み
filename = '美声.wav';
[audioData, samplingRate] = audioread(filename);
%sound(audioData, samplingRate);

% 短時間信号への分割
frameLength_sec = 0.02;     % フレーム長
frameShift_sec = 0.01;      % フレームシフト長

% サンプル単位のフレーム長とシフト長に変換
frameLength = round(frameLength_sec * samplingRate);
frameShift = round(frameShift_sec * samplingRate);

% 信号の長さを取得
signalLength = length(audioData);

% フレーム数を計算
numFrames = floor((signalLength - frameLength) / frameShift) + 1;

% 短時間信号を格納する行列を初期化
frames = zeros(frameLength, numFrames);

% フレームの抽出
for i = 1:numFrames
    startIndex = (i - 1) * frameShift + 1;
    endIndex = startIndex + frameLength -1;
    
    if endIndex > signalLength
        frames(:, i) = [audioData(startIndex:signalLength); zeros(endIndex - signalLength, 1)];
    else
        frames(:, i) = audioData(startIndex:endIndex);
    end
end

%disp(['分割されたフレーム数', num2str(numFrames)]);
%disp(['各フレームの長さ', num2str(size(frames, 1)), 'サンプル']);

% 窓関数（ハン窓）の実装
hanningWindow = hamming(frameLength);

% ハン窓を信号に乗算
windowedFrames = zeros(size(frames));
for i = 1:size(frames,2)
    windowedFrames(:, i) = frames(:, i) .* hanningWindow;
end


