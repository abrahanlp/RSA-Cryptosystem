clc
clear all

% Introduce nexte the file path to encrypt
file_in_path = "TestDataSet/Quijote.txt";

% Generates a prime random number
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


disp("=======================================");
disp("RSA encryption script for Octave/MATLAB");
disp("=======================================\r\n");

disp("Generating keys...")
tic()

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

% Keys generation time elapsed
toc()

disp("\r\nFile encryption...")

file_in = fopen(file_in_path, "rb");
if(file_in < 0)
  printf("Error opening input: %s\r\n", file_in);
  return;
end

data_in = uint8(fread(file_in, Inf, "uint8"));
fclose(file_in);
printf("%d bytes on \"%s\"\r\n", numel(data_in), file_in_path);

tic()
data_out = zeros(numel(data_in), 1, "uint32");

% Min, mean and max time encrypting bytes
min_t = 10;
max_t = 0;
mean_t = 0;

for i = 1 : 1024 %numel(data_in)
  t0 = clock();
  data_out(i) = modular_exp(data_in(i), e, n);
  byte_elap_time = etime(clock(), t0);
  if(byte_elap_time > max_t)
    max_t = byte_elap_time;
  elseif(byte_elap_time < min_t)
    min_t = byte_elap_time;
  end

  mean_t = (mean_t + byte_elap_time) / 2;

  if (mod(i, 64) == 0)
    printf("%d Min:%d Mean:%d Max:%d\r\n", i, min_t, mean_t, max_t);
  end
end

% File encryption elapsed time
toc()

% Path where encrypted file will be stored
% Keys are append on file name for decrypting later
path_sufix = strcat("n", num2str(n), "d", num2str(d), ".cyph");
file_out_path = strrep(file_in_path, ".txt", path_sufix);

clear("i", "path_sufix")

file_out = fopen(file_out_path, "wb");
if(file_out < 0)
  printf("Error opening output: %s\r\n", file_in);
  return;
end

if(fwrite(file_out, data_out, "uint8") == numel(data_in))
  printf("%d encrypted bytes on \"%s\"\r\n", numel(data_in), file_out_path);
end

fclose(file_out);

