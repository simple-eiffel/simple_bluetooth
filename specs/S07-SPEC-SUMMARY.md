# S07: SPECIFICATION SUMMARY

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Executive Summary

simple_bluetooth provides Bluetooth Serial Port Profile (SPP) communication for Eiffel applications on Windows. It layers on simple_serial to discover paired Bluetooth devices and communicate via virtual COM ports.

## Key Classes

| Class | Purpose | LOC |
|-------|---------|-----|
| SIMPLE_BLUETOOTH | Main facade | 320 |
| BLUETOOTH_SCANNER | Device discovery | 161 |
| BLUETOOTH_DEVICE | Device info | ~100 |
| BLUETOOTH_SERIAL_PORT | Communication | ~150 |

## Core Capabilities

1. **Device Discovery**: Find paired Bluetooth COM ports
2. **Connection Management**: Open/close device connections
3. **Bidirectional I/O**: String and byte communication
4. **Configuration**: Baud rate presets and custom config
5. **Facade Pattern**: Simple, clean API

## Contract Summary

- 6 preconditions on SIMPLE_BLUETOOTH features
- 2 postconditions ensuring state consistency
- 2 class invariants maintaining integrity
- State machine: disconnected/connected

## Dependencies

| Library | Purpose |
|---------|---------|
| simple_serial | Serial port communication |
| EiffelBase | Standard library |

## Quality Attributes

| Attribute | Implementation |
|-----------|----------------|
| Simplicity | Facade pattern hides complexity |
| Reliability | Error handling via last_error |
| Extensibility | Phase 2 planned features |
| Portability | Windows Phase 1, expandable |

## Phase 1 Limitations

1. Windows only
2. No device name lookup
3. No MAC address lookup
4. Single connection at a time
