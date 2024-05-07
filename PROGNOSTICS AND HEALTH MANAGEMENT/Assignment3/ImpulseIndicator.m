% 冲击指标（Impulse Indicator）
function IM = ImpulseIndicator(X)

S = size(X);
L = max(S);
if (S(1)~=1&&S(2)==1)||(S(2)~=1&&S(1)==1)
    IM = max(abs(X))/(sum(abs(X))/L);
else 
    disp("Please input a multidimentional vector.")
end