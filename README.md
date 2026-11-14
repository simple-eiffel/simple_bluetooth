<p align="center">
  <img src="docs/images/logo.svg" alt="simple_bluetooth logo" width="400">
</p>

# simple_bluetooth

**[Documentation](https://simple-eiffel.github.io/simple_bluetooth/)** | **[GitHub](https://github.com/simple-eiffel/simple_bluetooth)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
![Windows: tests pass](https://img.shields.io/badge/Windows-tests%20pass-0078D6?logo=windows&logoColor=white) ![Linux: tests pass](https://img.shields.io/badge/Linux-tests%20pass-FCC624?logo=linux&logoColor=black) ![macOS: tests pass](https://img.shields.io/badge/macOS-tests%20pass-000000?logo=apple&logoColor=white)

Bluetooth communication library for Eiffel (Phase 1: Serial Port Profile).

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Phase 1** - 11 tests passing, Bluetooth SPP via simple_serial

## Overview

SIMPLE_BLUETOOTH provides Bluetooth Serial Port Profile (SPP) communication for Eiffel applications. Phase 1 builds on simple_serial to communicate with Bluetooth devices that appear as serial ports after pairing (COM ports on Windows, `/dev/cu.*` on macOS, `/dev/rfcommN` on Linux). Supports device discovery, connection management, and fluent configuration.

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
bluetooth.open_port ("COM6")  -- macOS: "/dev/cu.HC-05", Linux: "/dev/rfcomm0"

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
- **Device discovery** - Find paired Bluetooth serial ports (limited; see Known Limits)
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
On macOS or Linux:
```bash
export SIMPLE_EIFFEL=$HOME/simple_eiffel
```

2. Add to ECF:
```xml
<library name="simple_bluetooth" location="$SIMPLE_EIFFEL/simple_bluetooth/simple_bluetooth.ecf"/>
```

## Dependencies

- simple_serial

## Phase 1 Scope

This is Phase 1 implementation focusing on Bluetooth Serial Port Profile (SPP):
- Works with devices that appear as serial ports after pairing
- Pair devices in the OS first. On Linux, also bind the device as root: `rfcomm bind 0 <address>`.
- Full device name/address lookup planned for Phase 2 (name and address lookup return Void for now)

## Known Limits

- On Windows, `scan` finds the COM ports Windows describes as Bluetooth links ("Standard Serial over Bluetooth link", or a `BTHENUM` hardware id).
- On macOS and Linux, `scan` finds only ports whose names say Bluetooth or rfcomm (for example `/dev/cu.Bluetooth-Incoming-Port`). Open other ports by name, like `/dev/cu.HC-05`.
- On Linux, your user needs access to the port (usually the `dialout` group).
- Tests check the value objects only; they do not talk to real Bluetooth hardware.

## Requirements

- EiffelStudio 25.02+
- Windows 10+, macOS, or Linux with BlueZ
- simple_serial library
- Bluetooth SPP device, paired in the OS

## License

MIT License
