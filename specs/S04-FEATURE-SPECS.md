# S04: FEATURE SPECIFICATIONS

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## SIMPLE_BLUETOOTH Features

### scan
**Purpose**: Discover paired Bluetooth devices
**Behavior**: Delegates to BLUETOOTH_SCANNER.scan
**Effect**: Populates devices list

### open_device (device)
**Purpose**: Connect to specified Bluetooth device
**Behavior**:
1. Creates BLUETOOTH_SERIAL_PORT for device
2. Applies current config
3. Opens port
**Effect**: Sets active_port, is_connected becomes true

### open_port (port_name)
**Purpose**: Connect to Bluetooth device by COM port
**Behavior**:
1. Creates BLUETOOTH_SERIAL_PORT with port and config
2. Opens port
**Effect**: Sets active_port, is_connected becomes true

### close
**Purpose**: Disconnect from current device
**Behavior**:
1. Closes active_port
2. Sets active_port to Void
**Effect**: is_connected becomes false

### write (data): BOOLEAN
**Purpose**: Send string data to device
**Behavior**: Calls active_port.write_string
**Returns**: True if successful

### write_bytes (data): BOOLEAN
**Purpose**: Send raw bytes to device
**Behavior**: Calls active_port.write_bytes
**Returns**: True if successful

### read (max_length): STRING_8
**Purpose**: Read up to max_length characters
**Behavior**: Calls active_port.read_string
**Returns**: Data received (may be shorter than max)

### read_bytes (max_length): ARRAY [NATURAL_8]
**Purpose**: Read up to max_length bytes
**Behavior**: Calls active_port.read_bytes
**Returns**: Byte array

### read_line: STRING_8
**Purpose**: Read until newline or timeout
**Behavior**: Calls active_port.read_line
**Returns**: Line without newline character

## Configuration Features

### set_baud_rate (rate)
**Purpose**: Set baud rate for next connection
**Effect**: Updates config with new baud rate
**Common Values**: 9600, 38400, 115200

### config_9600: SERIAL_PORT_CONFIG
**Purpose**: Standard HC-05/HC-06 configuration
**Returns**: 9600-8-N-1 config

### config_115200: SERIAL_PORT_CONFIG
**Purpose**: Fast communication configuration
**Returns**: 115200-8-N-1 config

### config_38400: SERIAL_PORT_CONFIG
**Purpose**: OBD-II adapter configuration
**Returns**: 38400-8-N-1 config

## BLUETOOTH_SCANNER Features

### scan
**Purpose**: Find Bluetooth COM ports
**Behavior**:
1. Clears devices list
2. Refreshes simple_serial enumerator
3. Iterates bluetooth_ports
4. Creates BLUETOOTH_DEVICE for each
**Note**: Phase 1 creates devices with port only

### add_device_for_port (port)
**Purpose**: Create device entry for port
**Behavior**:
1. Queries device name (Phase 2: registry)
2. Queries MAC address (Phase 2: registry)
3. Creates BLUETOOTH_DEVICE
4. Adds to devices list
