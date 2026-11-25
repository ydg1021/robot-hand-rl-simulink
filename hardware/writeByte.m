function writeByte(serialPort, id, address, value)
    packet = [255, 255, id, 4, 3, address, value, 0];
    packet(end) = mod(-sum(packet(3:end-1)), 256);
    fwrite(serialPort, packet);
end