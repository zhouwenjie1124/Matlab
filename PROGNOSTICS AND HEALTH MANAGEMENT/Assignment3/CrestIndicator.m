% 峰值指标（Crest Indicator/Factor），也叫峰值因数。
function CR = CrestIndicator(X)

S = size(X);
L = max(S);
if (S(1)~=1&&S(2)==1)||(S(2)~=1&&S(1)==1)
    CR = max(abs(X))/rms(X);
else 
    disp("Please input a multidimentional vector.")
end