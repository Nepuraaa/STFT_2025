function S = STFT(audioData, Fs, windowLength, shiftWidth)

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

P = abs(S .^ 2);

% パワースペクトログラムを表示
f = (0:windowLength - 1) * (Fs / windowLength);     %周波数軸
f = f(:);
t = linspace(0, sigLen / Fs, numFrames);            %時間軸
P = 10 * log10(P);                                  %強さを対数表示

image = imagesc(t, f, P);
axis xy;

title('パワースペクトルグラム');
xlabel('時間 [s]');
ylabel('周波数 [Hz]');

f_max = max(f);                     % y軸のメモリを2000刻み
yticks(0:2000:f_max/2);

ylim([0 f_max/2]);

ax = ancestor(image, 'axes');       %指数表示やめる
ax.YAxis.Exponent = 0;

c = colorbar;                       % カラーバー
c.Label.String = '信号の強さ [dB]';

end
