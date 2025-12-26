note
	description: "[
		SIMPLE_BLUETOOTH - Main facade for Bluetooth Serial communication

		Phase 1 Implementation: Bluetooth Serial Port Profile (SPP)

		Bluetooth SPP devices appear as virtual COM ports after pairing.
		This library provides a higher-level API for discovering and
		communicating with paired Bluetooth devices.

		Example:
			bluetooth: SIMPLE_BLUETOOTH
			create bluetooth

			-- Scan for paired devices
			bluetooth.scan
			across bluetooth.devices as d loop
				print (d.display_name + "%%N")
			end

			-- Open first device
			if bluetooth.has_devices then
				bluetooth.open_device (bluetooth.devices.first)
				if bluetooth.is_connected then
					bluetooth.write ("AT+VERSION?")
					print (bluetooth.read (50))
					bluetooth.close
				end
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_BLUETOOTH

inherit
	ANY
		redefine
			default_create
		end

create
	default_create,
	make_with_config

feature {NONE} -- Initialization

	default_create
			-- Initialize with default configuration.
		do
			create scanner.make
			create config.make_default
		end

	make_with_config (a_config: SERIAL_PORT_CONFIG)
			-- Initialize with custom serial configuration.
		require
			config_exists: a_config /= Void
		do
			create scanner.make
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Access

	devices: ARRAYED_LIST [BLUETOOTH_DEVICE]
			-- List of discovered Bluetooth devices.
		do
			Result := scanner.devices
		end

	device_count: INTEGER
			-- Number of discovered devices.
		do
			Result := scanner.device_count
		end

	current_device: detachable BLUETOOTH_DEVICE
			-- Currently connected device.
		do
			if attached active_port as p then
				Result := p.device
			end
		end

	config: SERIAL_PORT_CONFIG
			-- Serial port configuration for connections.

	last_error: detachable STRING_32
			-- Last error message.
		do
			if attached active_port as p then
				Result := p.last_error
			end
		end

feature -- Status

	has_devices: BOOLEAN
			-- Were any Bluetooth devices discovered?
		do
			Result := scanner.has_devices
		end

	is_connected: BOOLEAN
			-- Is a Bluetooth device currently connected?
		do
			Result := attached active_port as p and then p.is_open
		end

	has_error: BOOLEAN
			-- Did the last operation produce an error?
		do
			Result := last_error /= Void
		end

feature -- Discovery

	scan
			-- Scan for paired Bluetooth devices.
		do
			scanner.scan
		end

	refresh
			-- Re-scan for devices.
		do
			scanner.refresh
		end

	device_for_port (a_port: READABLE_STRING_GENERAL): detachable BLUETOOTH_DEVICE
			-- Find device using specified COM port.
		do
			Result := scanner.device_for_port (a_port)
		end

feature -- Connection

	open_device (a_device: BLUETOOTH_DEVICE)
			-- Open connection to Bluetooth device.
		require
			device_exists: a_device /= Void
			not_connected: not is_connected
		do
			create active_port.make_for_device (a_device)
			if attached active_port as p then
				p.set_config (config)
				p.open
			end
		ensure
			connected_or_error: is_connected or has_error
		end

	open_port (a_port: READABLE_STRING_GENERAL)
			-- Open connection to Bluetooth device on specified port.
		require
			port_not_empty: not a_port.is_empty
			not_connected: not is_connected
		do
			create active_port.make_with_config (a_port, config)
			if attached active_port as p then
				p.open
			end
		ensure
			connected_or_error: is_connected or has_error
		end

	close
			-- Close current connection.
		require
			is_connected: is_connected
		do
			if attached active_port as p then
				p.close
			end
			active_port := Void
		ensure
			not_connected: not is_connected
		end

feature -- Communication

	write (a_data: READABLE_STRING_8): BOOLEAN
			-- Write string data to connected device.
		require
			is_connected: is_connected
			data_exists: a_data /= Void
			data_not_empty: not a_data.is_empty
		do
			if attached active_port as p then
				Result := p.write_string (a_data)
			end
		end

	write_bytes (a_data: ARRAY [NATURAL_8]): BOOLEAN
			-- Write raw bytes to connected device.
		require
			is_connected: is_connected
			data_exists: a_data /= Void
			data_not_empty: not a_data.is_empty
		do
			if attached active_port as p then
				Result := p.write_bytes (a_data)
			end
		end

	read (a_max_length: INTEGER): STRING_8
			-- Read up to `a_max_length` characters from device.
		require
			is_connected: is_connected
			positive_length: a_max_length > 0
		do
			if attached active_port as p then
				Result := p.read_string (a_max_length)
			else
				create Result.make_empty
			end
		ensure
			result_exists: Result /= Void
		end

	read_bytes (a_max_length: INTEGER): ARRAY [NATURAL_8]
			-- Read up to `a_max_length` bytes from device.
		require
			is_connected: is_connected
			positive_length: a_max_length > 0
		do
			if attached active_port as p then
				Result := p.read_bytes (a_max_length)
			else
				create Result.make_empty
			end
		ensure
			result_exists: Result /= Void
		end

	read_line: STRING_8
			-- Read until newline or timeout.
		require
			is_connected: is_connected
		do
			if attached active_port as p then
				Result := p.read_line
			else
				create Result.make_empty
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Configuration

	set_config (a_config: SERIAL_PORT_CONFIG)
			-- Set serial configuration (applies to next connection).
		require
			config_exists: a_config /= Void
			not_connected: not is_connected
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

	set_baud_rate (a_rate: INTEGER)
			-- Set baud rate (applies to next connection).
		require
			not_connected: not is_connected
			valid_rate: a_rate > 0
		do
			config := config.set_baud_rate (a_rate)
		ensure
			rate_set: config.baud_rate = a_rate
		end

feature -- Factory

	config_9600: SERIAL_PORT_CONFIG
			-- Standard 9600-8-N-1 configuration (common for HC-05/HC-06).
		do
			create Result.make_default
		ensure
			baud_9600: Result.baud_rate = 9600
		end

	config_115200: SERIAL_PORT_CONFIG
			-- Fast 115200-8-N-1 configuration.
		do
			create Result.make_default
			Result := Result.set_baud_rate (115200)
		ensure
			baud_115200: Result.baud_rate = 115200
		end

	config_38400: SERIAL_PORT_CONFIG
			-- 38400-8-N-1 configuration (some OBD-II adapters).
		do
			create Result.make_default
			Result := Result.set_baud_rate (38400)
		ensure
			baud_38400: Result.baud_rate = 38400
		end

feature {NONE} -- Implementation

	scanner: BLUETOOTH_SCANNER
			-- Device scanner.

	active_port: detachable BLUETOOTH_SERIAL_PORT
			-- Currently active Bluetooth port.

invariant
	scanner_exists: scanner /= Void
	config_exists: config /= Void

end
