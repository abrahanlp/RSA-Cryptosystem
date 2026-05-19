clear all;
clc;
% Test cases

% Manual Test
disp('Manual Test');
candidate_test = uint64([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 32, 27, 35]);
test_expected = ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0]);
test_result = zeros(1, length(candidate_test));

for i = 1 : length(candidate_test)
  test_result(i) = miller_rabin(candidate_test(i));
  if (test_expected(i) != test_result(i))
    printf("Candidate %d fail\r\n", candidate);
  endif
endfor

% First n primes
disp('First n Primes Test');
candidate_test = uint64(primes(1000));
for candidate = candidate_test
  if(isprime(candidate) != miller_rabin(candidate))
    printf("Candidate %d fail\r\n", candidate);
  endif
endfor

% Random test
disp('Random Test');
candidate_test = randi(2000, 1, 10, "uint32");
for candidate = candidate_test
  test_expected = isprime(candidate);
  if(test_expected != miller_rabin(candidate))
    printf("Candidate %d is %d\r\n", candidate, test_expected);
  endif
endfor

