# S03: CONTRACTS

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## SIMPLE_BLUETOOTH Contracts

### Feature: make_with_config
```eiffel
make_with_config (a_config: SERIAL_PORT_CONFIG)
    require
        config_exists: a_config /= Void
    ensure
        config_set: config = a_config
```

### Feature: open_device
```eiffel
open_device (a_device: BLUETOOTH_DEVICE)
    require
        device_exists: a_device /= Void
        not_connected: not is_connected
    ensure
        connected_or_error: is_connected or has_error
```

### Feature: open_port
```eiffel
open_port (a_port: READABLE_STRING_GENERAL)
    require
        port_not_empty: not a_port.is_empty
        not_connected: not is_connected
    ensure
        connected_or_error: is_connected or has_error
```

### Feature: close
```eiffel
close
    require
        is_connected: is_connected
    ensure
        not_connected: not is_connected
```

### Feature: write
```eiffel
write (a_data: READABLE_STRING_8): BOOLEAN
    require
        is_connected: is_connected
        data_exists: a_data /= Void
        data_not_empty: not a_data.is_empty
```

### Feature: read
```eiffel
read (a_max_length: INTEGER): STRING_8
    require
        is_connected: is_connected
        positive_length: a_max_length > 0
    ensure
        result_exists: Result /= Void
```

## BLUETOOTH_SCANNER Contracts

### Feature: device_at
```eiffel
device_at (a_index: INTEGER): BLUETOOTH_DEVICE
    require
        valid_index: a_index >= 1 and a_index <= device_count
```

### Invariant
```eiffel
invariant
    devices_exists: devices /= Void
    enumerator_exists: serial_enumerator /= Void
```

## SIMPLE_BLUETOOTH Invariants

```eiffel
invariant
    scanner_exists: scanner /= Void
    config_exists: config /= Void
```
