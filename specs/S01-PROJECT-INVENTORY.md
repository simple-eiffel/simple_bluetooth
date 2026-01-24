# S01: PROJECT INVENTORY

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Project Structure

```
simple_bluetooth/
├── simple_bluetooth.ecf        # Library configuration
├── src/
│   ├── simple_bluetooth.e      # Main facade class
│   ├── bluetooth_scanner.e     # Device discovery
│   ├── bluetooth_device.e      # Device information
│   ├── bluetooth_serial_port.e # Communication wrapper
│   └── serial_port_config.e    # Configuration (may be from simple_serial)
├── testing/
│   ├── test_app.e              # Test application root
│   └── lib_tests.e             # Test suite
├── research/                   # This directory
└── specs/                      # Specification directory
```

## File Count Summary

| Category | Files |
|----------|-------|
| Core source | 4 |
| Test files | 2 |
| Configuration | 1 |
| **Total** | **7** |

## External Dependencies

### Eiffel Libraries
- EiffelBase (standard library)
- simple_serial (serial port communication)

### System Requirements
- Windows (COM port model)
- Bluetooth adapter (hardware)
- Paired Bluetooth devices
