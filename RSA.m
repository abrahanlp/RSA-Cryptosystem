clc, clear all;

disp("===================================");
disp("RSA cypher script for Octave/MATLAB");
disp("===================================");

function prime_n = get_random_prime()
  do
    % Get a random number between 47 and max_uint32
    % on uint32 format
    prime_n = randi([47, intmax('uint16')], "uint32");
  until(isprime(prime_n))
  endfunction

% Look for Great Commond Divider by
% the Euclides Algorithm
function mcd = euclides_algorithm (a, b)
  while(b ~= 0)
    aux = rem(a, b);
    a = b;
    b = aux;
  endwhile
  mcd = a;
  endfunction

function [d, x, y] = blankinship(a, b)
  % Cast
  a = int64(a);
  b = int64(b);

  % Initialize
  row_a = int64([a, 1, 0]);
  row_b = int64([b, 0, 1]);

  while row_b(1) ~= 0
    q = idivide(row_a(1), row_b(1), 'floor');

    % New row
    fila_temp = row_a - q * row_b;

    % Update rows
    row_a = row_b;
    row_b = fila_temp;
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

p = uint64(get_random_prime())
q = uint64(get_random_prime())

n = p * q
phi = (p - 1)*(q - 1)

e = uint64(65537)

[gcd, d, y] = blankinship(e, phi);

if(d < 0)
  d = d + int64(phi);
end

d = uint64(d)

if((gcd ~= 1) || (rem(e*uint64(d), phi) ~= 1))
  printf("GCD = %d | rem(e * d, phi) = %d\r\n", gcd, rem(e*uint64(d), phi))
  return
end

clear("gcd", "y")

disp("END")

