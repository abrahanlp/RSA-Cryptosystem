% Extended Euclidean Algorithm
% Gets 'a' and 'b' GCD with 'x' and 'y'
% such that a*x + b*y = mcd(a, b)
function [mcd, x, y] = euclides_extended(a, b)
  a = int64(a);
  b = int64(b);

  x0 = int64(1); x1 = int64(0);
  y0 = int64(0); y1 = int64(1);

  while b ~= 0
    q = idivide(a, b, 'fix');
    r = a - q * b;

    a = b;
    b = r;

    x_next = x0 - q * x1;
    y_next = y0 - q * y1;

    x0 = x1; x1 = x_next;
    y0 = y1; y1 = y_next;
  end

  mcd = a;
  x = x0;
  y = y0;

end

