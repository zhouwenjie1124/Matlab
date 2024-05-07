% Boxplot drawing
function [] = BPself(X,T)

b = boxplot(X);
title(T)
h = findobj(gca,'tag','boxplot'); obj = get(h,'children');
obj(21).LineStyle = '-';obj(22).LineStyle = '-';obj(23).LineStyle = '-';obj(24).LineStyle = '-';obj(25).LineStyle = '-';obj(26).LineStyle = '-';obj(27).LineStyle = '-';obj(28).LineStyle = '-'; %改虚线线型为实线
set(gca,'XtickLabel',{'N','IR','OR','B'})
end