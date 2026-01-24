# 7S-02: STANDARDS

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Applicable Standards

### Bluetooth Specifications

1. **Bluetooth Serial Port Profile (SPP)**
   - Based on RFCOMM protocol
   - Emulates RS-232 serial port
   - Uses virtual COM port on Windows

2. **Bluetooth Core Specification**
   - Device discovery protocols
   - Pairing and bonding
   - (Handled by Windows, not this library)

### Serial Communication Standards

1. **RS-232**
   - Asynchronous serial communication
   - Configurable baud rate, data bits, parity, stop bits

2. **Virtual COM Ports**
   - Windows creates COMx for paired Bluetooth SPP devices
   - Appears as standard serial port

### Windows APIs

1. **SetupDi API**
   - Device enumeration
   - Finding Bluetooth COM ports

2. **Win32 Serial API**
   - CreateFile for COM port access
   - ReadFile/WriteFile for I/O
   - Handled by simple_serial

## Common Configurations

### HC-05/HC-06 Modules
- Default baud: 9600 (AT mode: 38400)
- Data bits: 8
- Parity: None
- Stop bits: 1

### OBD-II Adapters (ELM327)
- Common baud: 38400
- Some use: 115200
- Auto-baud detection in some adapters

### Device Addressing
- Bluetooth MAC: XX:XX:XX:XX:XX:XX
- Windows assigns COM port number
- Registry maps device to port
