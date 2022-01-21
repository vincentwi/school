function f = goldstein_price(x)
X=x(1);
Y=x(2);

    a = 1+(X+Y+1).^2.*(19-14*X+3*X.^2-14*Y+6*X.*Y+3*Y.^2);
    b = 30+(2*X-3*Y).^2.*(18-32*X+12*X.^2+48*Y-36*X.*Y+27*Y.^2);
    f = a.*b;
end
        