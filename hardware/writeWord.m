function writeWord(serialPort, id, address, value)
    lowByte = mod(value, 256);
    highByte = mod(floor(value / 256), 256);
    packet = [255, 255, id, 5, 3, address, lowByte, highByte, 0];
    packet(end) = mod(-sum(packet(3:end-1)), 256);
    fwrite(serialPort, packet);
end