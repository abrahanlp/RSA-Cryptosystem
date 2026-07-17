function RSA_Decrypt(file_in_path)

  disp("=======================================");
  disp("RSA decription script for Octave/MATLAB");
  disp("=======================================\r\n");


  disp("Getting keys...\r\n")
  % %*[^_] Means read everything except '_'
  values_tmp = sscanf(file_in_path, "%*[^_]_n%ud%u");

  if length(values_tmp) == 2
      n = uint32(values_tmp(1));
      d = uint32(values_tmp(2));
  else
      disp('There are no keys on %s\r\n', file_in_path);
      return;
  end

  file_in = fopen(file_in_path, "rb");
  if(file_in < 0)
    printf("Error opening input: %s\r\n", file_in);
    return;
  end

  data_in = uint32(fread(file_in, Inf, "uint32"));
  fclose(file_in);

  disp("\r\nFile decryption...")
  tic()
  data_out = zeros(numel(data_in), 1, "uint8");

  % Min, mean and max time decrypting bytes
  min_t = 10;
  max_t = 0;
  mean_t = 0;

  for i = 1 : numel(data_in)
    t0 = clock();
    data_out(i) = modular_exp(data_in(i), d, n);
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

  % File decryption elapsed time
  toc()

  % Path where decrypted file will be stored
  file_out_path = strrep(file_in_path, ".cyph", "_decyphered.txt");

  clear("i")

  file_out = fopen(file_out_path, "w");
  if(file_out < 0)
    printf("Error opening output: %s\r\n", file_in);
    return;
  end

  if(fwrite(file_out, data_out, "uint8") == numel(data_in))
    printf("%d decrypted bytes on \"%s\"\r\n", numel(data_in), file_out_path);
  end

  fclose(file_out);
endfunction
