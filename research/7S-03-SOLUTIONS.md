# 7S-03: SOLUTIONS

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Existing Solutions Comparison

### Windows Native

| Solution | Pros | Cons |
|----------|------|------|
| Windows Bluetooth API | Full control | Complex C++ API |
| WinRT Bluetooth | Modern, async | .NET/UWP only |
| COM port direct | Simple | No device discovery |

### Cross-Platform

| Solution | Pros | Cons |
|----------|------|------|
| BlueZ (Linux) | Full featured | Linux only |
| PyBluez | Python bindings | Python only |
| Qt Bluetooth | Cross-platform | Heavy dependency |

### Eiffel Ecosystem

- simple_serial: Serial port access (used as base)
- No Bluetooth-specific library before simple_bluetooth

## Why Build simple_bluetooth?

1. **Fill Ecosystem Gap**: No Eiffel Bluetooth library
2. **Leverage simple_serial**: Build on existing serial support
3. **SPP Focus**: Most common embedded use case
4. **Simple API**: Discovery + communication in few calls

## Design Decisions

1. **Layer on simple_serial**
   - Bluetooth SPP appears as COM port
   - Reuse proven serial code
   - Add device discovery layer

2. **Windows-First (Phase 1)**
   - Primary platform for ecosystem
   - COM port model well-defined
   - Registry for device info

3. **Paired Devices Only**
   - Pairing requires user interaction
   - Windows handles pairing UI
   - Library works with already-paired devices

4. **Facade Pattern**
   - SIMPLE_BLUETOOTH as main entry point
   - Hides scanner and port details
   - Simple: scan, connect, read/write

## Architecture

```
SIMPLE_BLUETOOTH (facade)
     │
     ├── BLUETOOTH_SCANNER (discovery)
     │        └── SERIAL_PORT_ENUMERATOR (from simple_serial)
     │
     ├── BLUETOOTH_DEVICE (device info)
     │
     └── BLUETOOTH_SERIAL_PORT (communication)
              └── SERIAL_PORT (from simple_serial)
```
