

%TODO This function only works with multiple of 32bit numbers
%     improve it by adding support to random size
function [prime] = GetPrimeNumber(prime_sz)
  prime_sz = 64;  %TODO Only debug , remove at production

  t0 = clock();

  words = prime_sz / 32;

  % Generates 'prime_sz' bit random number
  prime = randi(intmax('uint32'), 1, words, "uint32");
  % Sets first bit to avoid even numbers
  prime(1) = bitset(prime(1), 1);
  % Sets MSB to assure 'prime_sz' size number
  prime(words) = bitset(prime(words), 32);

  elapsed_time = etime(clock(), t0);
  disp([' Generated ', num2str(prime_sz), 'bit prime number on ', ...
          num2str(elapsed_time), ' seconds.']);
  endfunction

