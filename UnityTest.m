clear all;
clc;

% For performance measure
t0 = clock();

  % Test cases
% First n primes
disp('First n Primes Test');
candidate_test = uint64(primes(5000));
for candidate = candidate_test
  if(isprime(candidate) != miller_rabin(candidate))
    printf("Candidate %d fail\r\n", candidate);
  endif
endfor

% Random test
disp('Random Test');
candidate_test = randi(5000, 1, 100, "uint32");
for candidate = candidate_test
  test_expected = isprime(candidate);
  if(test_expected != miller_rabin(candidate))
    printf("Candidate %d is %d\r\n", candidate, test_expected);
  endif
endfor

elapsed_time = etime(clock(), t0);
printf("elapsed %d\r\n\r\n", elapsed_time);

