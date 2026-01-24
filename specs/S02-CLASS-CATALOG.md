# S02: CLASS CATALOG

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Core Classes

### SIMPLE_BLUETOOTH
**Purpose**: Main facade for Bluetooth SPP communication
**Inherits**: ANY
**Key Features**:
- `scan`: Discover paired Bluetooth devices
- `refresh`: Re-scan for devices
- `devices`: List of discovered devices
- `device_for_port (port)`: Find device by COM port
- `open_device (device)`: Connect to device
- `open_port (port)`: Connect by port name
- `close`: Disconnect current connection
- `write (data)`, `write_bytes (data)`: Send data
- `read (max)`, `read_bytes (max)`: Receive data
- `read_line`: Read until newline
- `is_connected`, `has_devices`, `has_error`: Status
- `config_9600`, `config_115200`, `config_38400`: Presets

### BLUETOOTH_SCANNER
**Purpose**: Discovers paired Bluetooth devices
**Inherits**: None
**Key Features**:
- `scan`: Scan for Bluetooth COM ports
- `refresh`: Re-scan
- `devices`: Discovered device list
- `device_count`: Number of devices
- `device_at (index)`: Get device by index
- `device_for_port (port)`: Find by port
- `has_devices`, `is_scanning`: Status

### BLUETOOTH_DEVICE
**Purpose**: Information about a Bluetooth device
**Inherits**: None
**Key Features**:
- `name`: Device name (Phase 2)
- `address`: MAC address (Phase 2)
- `port_name`: COM port (e.g., "COM5")
- `display_name`: Human-readable name
- `is_same_port (port)`: Port comparison
- `make (name, address, port)`: Standard creation
- `make_unknown (port)`: Port-only creation (Phase 1)

### BLUETOOTH_SERIAL_PORT
**Purpose**: Serial communication to Bluetooth device
**Inherits**: None
**Key Features**:
- `make_for_device (device)`: Create for device
- `make_with_config (port, config)`: Create with config
- `open`, `close`: Connection lifecycle
- `write_string (data)`: Send string
- `write_bytes (data)`: Send bytes
- `read_string (max)`: Read string
- `read_bytes (max)`: Read bytes
- `read_line`: Read until newline
- `is_open`: Connection status
- `device`: Associated device
- `last_error`: Error message
