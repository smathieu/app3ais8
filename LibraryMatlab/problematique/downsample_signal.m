function data = downsample_signal(x, f, Fe)
    data_size = size(x, 1);
    x_fft = fft(x, data_size);

    data = real(ifft(x_fft(1:2*f), round(data_size/Fe*f)));