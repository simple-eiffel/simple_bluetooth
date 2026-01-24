# S06: BOUNDARIES

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## System Boundaries

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      Eiffel Application                          │
├─────────────────────────────────────────────────────────────────┤
│                     simple_bluetooth                             │
│                                                                  │
│  ┌─────────────────────┐    ┌─────────────────────────────┐   │
│  │  SIMPLE_BLUETOOTH   │    │    BLUETOOTH_SCANNER        │   │
│  │     (facade)        │    │    (discovery)              │   │
│  └─────────┬───────────┘    └─────────┬───────────────────┘   │
│            │                          │                         │
│  ┌─────────┴───────────┐    ┌─────────┴───────────────────┐   │
│  │BLUETOOTH_SERIAL_PORT│    │    BLUETOOTH_DEVICE         │   │
│  │  (communication)    │    │    (device info)            │   │
│  └─────────┬───────────┘    └─────────────────────────────┘   │
│            │                                                    │
└────────────┼────────────────────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────────────────────┐
│                        simple_serial                             │
│  ┌─────────────────────┐    ┌─────────────────────────────┐   │
│  │    SERIAL_PORT      │    │  SERIAL_PORT_ENUMERATOR    │   │
│  │                     │    │                             │   │
│  └─────────┬───────────┘    └─────────────────────────────┘   │
│            │                                                    │
└────────────┼────────────────────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────────────────────┐
│                   Windows Serial API                             │
│            (CreateFile, ReadFile, WriteFile)                    │
└─────────────────────────────────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────────────────────┐
│                  Bluetooth Hardware                              │
│       (Adapter → Paired Device → Physical Device)               │
└─────────────────────────────────────────────────────────────────┘
```

## Interface Boundaries

### Public API
- SIMPLE_BLUETOOTH: Main facade
- BLUETOOTH_DEVICE: Device information
- SERIAL_PORT_CONFIG: Configuration (from simple_serial)

### Internal Implementation
- BLUETOOTH_SCANNER: Used by facade
- BLUETOOTH_SERIAL_PORT: Used by facade
- simple_serial classes: Foundation layer

## Data Flow

### Discovery
```
Windows Registry → SERIAL_PORT_ENUMERATOR → BLUETOOTH_SCANNER → devices
```

### Communication
```
Application → SIMPLE_BLUETOOTH → BLUETOOTH_SERIAL_PORT → SERIAL_PORT → COM port → Device
```

## Integration Points

### simple_serial
- SERIAL_PORT for communication
- SERIAL_PORT_ENUMERATOR for discovery
- SERIAL_PORT_CONFIG for configuration

### Application Code
- Direct use of SIMPLE_BLUETOOTH facade
- Access to device list for selection UI
- Read/write operations for protocols
