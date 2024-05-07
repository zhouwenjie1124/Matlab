% 形状指标（Shape Indicator）
function SH = ShapeIndicator(X)

S = size(X);
L = max(S);
if (S(1)~=1&&S(2)==1)||(S(2)~=1&&S(1)==1)
    SH = rms(X)/(sum(abs(X))/L);
else 
    disp("Please input a multidimentional vector.")
end