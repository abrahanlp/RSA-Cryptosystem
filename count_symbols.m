function [symbols, frequencies] = count_symbols(filepath, sym_size)
    % Check symbol size
    if sym_size == 8
        data_type = '*uint8';
    elseif sym_size == 32
        data_type = '*uint32';
    else
        error('Symbol size must be 8 or 32.');
    end

    fid = fopen(filepath, 'rb');
    if fid == -1
        error('Error opening %s.', filepath);
    end

    % Read the entire file
    data = fread(fid, inf, data_type);
    fclose(fid);

    % If file empty
    if isempty(data)
        warning('File is empty.');
        symbols = [];
        frequencies = [];
        return;
    end

    % 4. Count repetitions (frequency)
    % unique() identifies the symbols present in the data
    % accumarray() counts how many times each symbol index appears
    [symbols, ~, idx] = unique(data);
    frequencies = accumarray(idx, 1);

    % 5. Plot histogram
    figure('Name', 'Symbol Histogram', 'NumberTitle', 'off');

    if sym_size == 8
        % 8 bits (0-255)
        bar(double(symbols), frequencies, 'hist');
        xlim([0, 255]);
    else
        % 32 bits, values can be widely spaced out.
        % Use 'stem' to represent the exact peaks found.
        stem(double(symbols), frequencies, 'Marker', 'none', 'LineWidth', 1.5);
    end

    % Graph formatting
    title(sprintf('%d-bit Symbols Frequency', sym_size));
    xlabel('Decimal Symbol Value');
    ylabel('Count');
    grid on;
end

