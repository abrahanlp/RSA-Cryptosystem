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

