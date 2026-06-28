clc
clear all

% Introduce nexte the file path to encrypt
file_in_path = "TestDataSet/Quijote.txt";



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

[gcd, d, y] = euclides_extended(e, phi);

if(d < 0)
  d = d + int64(phi);
end

d = uint64(d)

if((abs(gcd) ~= 1) || (rem(e*d, phi) ~= 1))
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

for i = 1 : numel(data_in)
  t0 = clock();
  data_out(i) = modular_exp(data_in(i), e, n);
  byte_elap_time = etime(clock(), t0);
  if(byte_elap_time > max_t)
    max_t = byte_elap_time;
  elseif(byte_elap_time < min_t)
    min_t = byte_elap_time;
  end

  mean_t = (mean_t + byte_elap_time) / 2;

  if (mod(i, 65536) == 0)
    printf("%d Min:%d Mean:%d Max:%d\r\n", i, min_t, mean_t, max_t);
  end
end

% File encryption elapsed time
toc()

% Path where encrypted file will be stored
% Keys are append on file name for decrypting later
path_sufix = strcat("_n", num2str(n), "d", num2str(d), ".cyph");
file_out_path = strrep(file_in_path, ".txt", path_sufix);

clear("i", "path_sufix")

file_out = fopen(file_out_path, "wb");
if(file_out < 0)
  printf("Error opening output: %s\r\n", file_in);
  return;
end

if(fwrite(file_out, data_out, "uint32") == numel(data_in))
  printf("%d encrypted bytes on \"%s\"\r\n", numel(data_in), file_out_path);
end

fclose(file_out);

