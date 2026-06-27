% Generates a prime random number
function prime_n = get_random_prime()
  do
    % Get a random number between 47 and max_uint32
    % on uint32 format
    prime_n = randi([47, intmax('uint16')], "uint32");
  until(isprime(prime_n))
endfunction

