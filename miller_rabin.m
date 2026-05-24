%Only debug, comment with function structure
%clc;
%clear all;
%n = ##;

function is_prime = miller_rabin(n)
  % Base cases
  is_prime = true;

  if(n <= 3 && n >=1)
    if(n == 1)
      is_prime = false;
    endif
    return;
  endif
  if(!bitand(n, 1))
    is_prime = false;
    return;
   endif

  % For performance measure
  %t0 = clock();

  n = uint64(n);

  % Base cases
  %a = uint64([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]);
  a = uint64([2, 3]);

  % Get n - 1 = (2^s)*d
  s = uint32(0);
  nm1 = uint32(n - 1);

  % 's' is getted by dividing as much as posible by 2
  while (mod(nm1, 2) == 0)
    s = s + 1;
    nm1 = nm1 / 2;
  endwhile

  % 'd' will be the slice that can not be divided by 2
  d = uint64(nm1);

  nm1 = n - 1;  % Restore original n - 1

  for bases = a
    % x = a^d % n; Test with base a(i)
    x = modular_exp(bases, d, n);

    if(x != 1 && x != nm1)
      i = 0;
      for i = 1 : s
        x = modular_exp(x, 2, n);
        if( x == nm1);
          % Possible prime
          break;
        endif
      endfor
      if (i == s)
        is_prime = false;
        break;  % Break from 'bases' loop
      endif
    endif
  endfor
  %elapsed_time = etime(clock(), t0);
%  printf("elapsed %d\r\n\r\n", elapsed_time);
endfunction

