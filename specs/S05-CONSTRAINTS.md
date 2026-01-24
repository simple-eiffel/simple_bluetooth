# S05: CONSTRAINTS

**Library**: simple_bluetooth
**Date**: 2026-01-23
**Status**: BACKWASH (reverse-engineered from implementation)

## Technical Constraints

### Platform Constraints
- **Windows only** (Phase 1): COM port model specific
- Bluetooth adapter required
- Devices must be paired via Windows

### Connection Constraints
- Single connection at a time
- Exclusive COM port access
- Cannot share port with other applications

### Communication Constraints
- Baud rate must match device
- No flow control in Phase 1
- Timeout depends on simple_serial defaults

### Device Discovery Constraints
- Only paired devices visible
- Registry lookup not implemented (Phase 1)
- Device name/address not available (Phase 1)

## API Constraints

### State Management
- Must not be connected before open_device/open_port
- Must be connected for read/write operations
- Close before opening different device

### Configuration
- Config changes apply to next connection only
- Cannot change baud rate while connected
- Default: 9600-8-N-1

### Data Handling
- read may return less than requested
- write returns success, not bytes sent
- read_line blocks until newline or timeout

## Serial Port Constraints

### Windows COM Ports
- Port names: COM1 through COM256
- Bluetooth typically COM4 and higher
- Port number assigned by Windows

### Baud Rate Support
| Rate | Support |
|------|---------|
| 9600 | Standard |
| 38400 | Supported |
| 115200 | Supported |
| Other | Depends on adapter |

## Error Handling

### Error Reporting
- last_error set on connection failure
- has_error query for status
- Operations return false on failure

### Common Errors
- Port already in use
- Device not available
- Baud rate mismatch
- Connection timeout
