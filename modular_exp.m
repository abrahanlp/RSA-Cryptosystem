
% Implements c = b^e mod(m) on big numbers
function c = modular_exp(b, e, m)
  b = uint64(b);
  e = uint64(e);
  m = uint64(m);

  c = uint64(1);

%  for i = 1 : e
%    c = mod(c * b, m);
%  endfor

  while(e > 0)
    if(bitand(e, 1))
      c = mod(c * b, m);
    end
    b = mod((b * b), m);
    e = bitshift(e, -1);
  endwhile
endfunction

