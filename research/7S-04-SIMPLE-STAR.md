# 7S-04: SIMPLE-STAR INTEGRATION

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Ecosystem Dependencies

### Required Libraries

1. **simple_serial**
   - Purpose: Serial port communication
   - Classes used: SERIAL_PORT, SERIAL_PORT_CONFIG, SERIAL_PORT_ENUMERATOR
   - Critical for: COM port I/O and enumeration

### EiffelStudio Libraries

2. **EiffelBase**
   - Standard collections and types

## Integration Patterns

### Device Discovery

```eiffel
-- Uses simple_serial's enumerator
serial_enumerator: SERIAL_PORT_ENUMERATOR
create serial_enumerator.make
serial_enumerator.refresh
across serial_enumerator.bluetooth_ports as port loop
    -- Found Bluetooth COM port
end
```

### Communication

```eiffel
-- BLUETOOTH_SERIAL_PORT wraps simple_serial's SERIAL_PORT
port: BLUETOOTH_SERIAL_PORT
create port.make_for_device (device)
port.set_config (config)
port.open
port.write_string ("AT+VERSION?")
response := port.read_string (100)
port.close
```

### Configuration

```eiffel
-- Uses simple_serial's SERIAL_PORT_CONFIG
config: SERIAL_PORT_CONFIG
create config.make_default  -- 9600-8-N-1
config := config.set_baud_rate (115200)
```

## Libraries Using simple_bluetooth

1. **IoT applications**: Sensor communication
2. **Automotive tools**: OBD-II diagnostics
3. **Robotics**: Controller communication

## Namespace Conventions

- All classes prefixed with BLUETOOTH_
- Facade: SIMPLE_BLUETOOTH
- No conflicts with simple_serial (different prefix)

## Future Integration

- simple_obd: OBD-II protocol over Bluetooth
- simple_iot: Generic IoT device support
