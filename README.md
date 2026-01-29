<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/.github/main/profile/assets/logo.svg" alt="simple_ library logo" width="400">
</p>

# simple_bluetooth

**[Documentation](https://simple-eiffel.github.io/simple_bluetooth/)** | **[GitHub](https://github.com/simple-eiffel/simple_bluetooth)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

Bluetooth communication library for Eiffel (Phase 1: Serial Port Profile).

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Phase 1** - 11 tests passing, Bluetooth SPP via simple_serial

## Overview

SIMPLE_BLUETOOTH provides Bluetooth Serial Port Profile (SPP) communication for Eiffel applications. Phase 1 builds on simple_serial to communicate with Bluetooth devices that appear as virtual COM ports after pairing. Supports device discovery, connection management, and fluent configuration.

## Quick Start

```eiffel
local
    bluetooth: SIMPLE_BLUETOOTH
do
    create bluetooth

    -- Scan for paired devices
    bluetooth.scan
    across bluetooth.devices as d loop
        print (d.display_name + "%N")
    end

    -- Connect to first device
    if bluetooth.has_devices then
        bluetooth.open_device (bluetooth.devices.first)
        if bluetooth.is_connected then
            if bluetooth.write ("AT+VERSION?") then
                print (bluetooth.read (50))
            end
            bluetooth.close
        end
    end
end
```

## Configuration

```eiffel
-- Custom baud rate (many Bluetooth modules default to 9600)
bluetooth: SIMPLE_BLUETOOTH

create bluetooth
bluetooth.set_baud_rate (115200)  -- For HC-05 in AT mode
bluetooth.open_port ("COM6")

-- Or use factory configs
create bluetooth.make_with_config (bluetooth.config_115200)
```

## Common Baud Rates

| Device Type | Typical Baud Rate |
|------------|-------------------|
| HC-05/HC-06 (data mode) | 9600 |
| HC-05 (AT mode) | 38400 |
| OBD-II adapters | 38400 or 115200 |
| GPS modules | 9600 or 4800 |

## Features

- **Bluetooth SPP support** - Communicate with paired Bluetooth Serial devices
- **Device discovery** - Find paired Bluetooth devices with virtual COM ports
- **Built on simple_serial** - Uses proven serial port infrastructure
- **Design by Contract** - Full preconditions/postconditions
- **SCOOP compatible** - Concurrency-ready design

## Classes

| Class | Description |
|-------|-------------|
| `SIMPLE_BLUETOOTH` | Main facade with connection management |
| `BLUETOOTH_SERIAL_PORT` | Port wrapper for SPP communication |
| `BLUETOOTH_SCANNER` | Discover paired devices |
| `BLUETOOTH_DEVICE` | Device information (name, address, port) |

## Installation

1. Set the ecosystem environment variable (one-time setup for all simple_* libraries):
```
SIMPLE_EIFFEL=D:\prod
```

2. Add to ECF:
```xml
<library name="simple_bluetooth" location="$SIMPLE_EIFFEL/simple_bluetooth/simple_bluetooth.ecf"/>
```

## Dependencies

- simple_serial

## Phase 1 Scope

This is Phase 1 implementation focusing on Bluetooth Serial Port Profile (SPP):
- Works with devices that appear as virtual COM ports after pairing
- Requires devices to be paired via Windows Bluetooth settings first
- Full device name/address lookup planned for Phase 2

## Requirements

- EiffelStudio 25.02+
- Windows 10+
- simple_serial library
- Bluetooth SPP device (paired via Windows)

## License

MIT License
