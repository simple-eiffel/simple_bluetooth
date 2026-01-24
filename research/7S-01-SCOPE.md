# 7S-01: SCOPE

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Problem Domain

Bluetooth Serial Port Profile (SPP) communication for Eiffel applications on Windows. The library enables discovering paired Bluetooth devices and communicating with them through virtual COM ports.

## Target Users

1. **IoT developers** connecting to Bluetooth sensors
2. **Hardware integrators** using Bluetooth modules (HC-05, HC-06)
3. **Automotive developers** using OBD-II Bluetooth adapters
4. **Robotics developers** communicating with Bluetooth controllers

## Primary Use Cases

1. Scan for paired Bluetooth devices
2. Connect to Bluetooth device via COM port
3. Send data (strings, bytes) to device
4. Receive data from device
5. Configure serial port parameters (baud rate)

## Boundaries

### In Scope
- Bluetooth SPP device discovery (paired devices)
- Serial port communication to Bluetooth devices
- Configurable baud rate (9600, 38400, 115200)
- String and byte-level I/O
- Line-based reading

### Out of Scope
- Bluetooth pairing (use Windows settings)
- Bluetooth Low Energy (BLE)
- Bluetooth audio profiles
- Direct HCI/L2CAP access
- Non-Windows platforms (Phase 1)

## Dependencies

- simple_serial: Serial port communication
- EiffelBase: Standard library
