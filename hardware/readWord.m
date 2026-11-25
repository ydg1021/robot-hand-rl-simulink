function value = readWord(serialPort, id, address)
    packet = [255, 255, id, 4, 2, address, 2, 0];
    packet(end) = mod(-sum(packet(3:end-1)), 256);
    fwrite(serialPort, packet);
    fread(serialPort, 6); % 헤더와 에러 바이트 읽기
    value = fread(serialPort, 1) + fread(serialPort, 1) * 256;
end
