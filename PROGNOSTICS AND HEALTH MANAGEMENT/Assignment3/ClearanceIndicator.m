% 间隔指标（Clearance Indicator）
function CL = ClearanceIndicator(X)

S = size(X);
L = max(S);
if (S(1)~=1&&S(2)==1)||(S(2)~=1&&S(1)==1)
    CL = max(abs(X))/(sum(sqrt(abs(X)))/L)^2;
else 
    disp("Please input a multidimentional vector.")
end