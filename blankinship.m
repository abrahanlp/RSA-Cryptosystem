% Finds solution for equation:
%   (a * x) + (b * y) = g.c.d(a, b)
% where g.c.d(a, b) = d
function [d, x, y] = blankinship(a, b)
  % Cast
  a = int64(a);
  b = int64(b);

  % Initialize
  row_a = int64([a, 1, 0]);
  row_b = int64([b, 0, 1]);

  while row_b(1) ~= 0

    q = idivide(row_a(1), row_b(1), 'fix'); //Random problems

    % New row
    row_temp = row_a - q * row_b;

    % Update rows
    row_a = row_b;
    row_b = row_temp;
  end

  % x sign to positive
  if (row_a(1) < 0)
    d = -row_a(1);
    x = -row_a(2);
    y = -row_a(3);
  else
    d = row_a(1);
    x = row_a(2);
    y = row_a(3);
  end
end

