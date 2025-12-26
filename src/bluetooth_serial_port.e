note
	description: "[
		BLUETOOTH_SERIAL_PORT - Bluetooth SPP communication via virtual COM port

		Wraps simple_serial's SERIAL_PORT for Bluetooth Serial Port Profile
		communication. Bluetooth SPP devices appear as virtual COM ports
		after pairing in Windows.

		Example:
			bt_port: BLUETOOTH_SERIAL_PORT
			create bt_port.make_for_device (my_device)
			bt_port.open
			if bt_port.is_open then
				bt_port.write_string ("AT+VERSION?")
				print (bt_port.read_string (50))
				bt_port.close
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	BLUETOOTH_SERIAL_PORT

create
	make,
	make_for_device,
	make_with_config

feature {NONE} -- Initialization

	make (a_port: READABLE_STRING_GENERAL)
			-- Create for specified COM port with default config (9600-8-N-1).
		require
			port_not_empty: not a_port.is_empty
		do
			create port_name.make_from_string_general (a_port)
			create config.make_default
			create serial_port.make (a_port)
		ensure
			port_set: port_name.same_string_general (a_port)
			not_open: not is_open
		end

	make_for_device (a_device: BLUETOOTH_DEVICE)
			-- Create for Bluetooth device with default config.
		require
			device_exists: a_device /= Void
		do
			device := a_device
			create port_name.make_from_string (a_device.com_port)
			create config.make_default
			create serial_port.make (a_device.com_port)
		ensure
			device_set: device = a_device
			port_set: port_name.same_string (a_device.com_port)
		end

	make_with_config (a_port: READABLE_STRING_GENERAL; a_config: SERIAL_PORT_CONFIG)
			-- Create with custom configuration.
		require
			port_not_empty: not a_port.is_empty
			config_exists: a_config /= Void
		do
			create port_name.make_from_string_general (a_port)
			config := a_config
			create serial_port.make (a_port)
		ensure
			port_set: port_name.same_string_general (a_port)
			config_set: config = a_config
		end

feature -- Access

	device: detachable BLUETOOTH_DEVICE
			-- Associated Bluetooth device (if created from device).

	port_name: STRING_32
			-- Virtual COM port name.

	config: SERIAL_PORT_CONFIG
			-- Serial port configuration.

	last_error: detachable STRING_32
			-- Last error message.

	last_read_count: INTEGER
			-- Number of bytes from last read operation.
		do
			Result := serial_port.last_read_count
		end

	last_write_count: INTEGER
			-- Number of bytes from last write operation.
		do
			Result := serial_port.last_write_count
		end

feature -- Status

	is_open: BOOLEAN
			-- Is the port currently open?
		do
			Result := serial_port.is_open
		end

	has_error: BOOLEAN
			-- Did the last operation produce an error?
		do
			Result := last_error /= Void
		end

	is_connected: BOOLEAN
			-- Is the Bluetooth device connected and responding?
			-- Note: A port can be open but device may be out of range.
		do
			-- Phase 1: Just check if port is open
			-- Future: Send probe command and check response
			Result := is_open
		end

feature -- Operations

	open
			-- Open the Bluetooth serial port.
		require
			not_open: not is_open
		do
			last_error := Void
			if not serial_port.open_with_config (config) then
				if attached serial_port.last_error as e then
					last_error := e.twin
				else
					create last_error.make_from_string ("Failed to open Bluetooth port")
				end
			end
		ensure
			open_or_error: is_open or has_error
		end

	close
			-- Close the Bluetooth serial port.
		require
			is_open: is_open
		do
			serial_port.close
			last_error := Void
		ensure
			not_open: not is_open
		end

	write_string (a_data: READABLE_STRING_8): BOOLEAN
			-- Write string data to Bluetooth device.
		require
			is_open: is_open
			data_exists: a_data /= Void
			data_not_empty: not a_data.is_empty
		do
			last_error := Void
			Result := serial_port.write_string (a_data)
			if not Result then
				if attached serial_port.last_error as e then
					last_error := e.twin
				end
			end
		end

	write_bytes (a_data: ARRAY [NATURAL_8]): BOOLEAN
			-- Write raw bytes to Bluetooth device.
		require
			is_open: is_open
			data_exists: a_data /= Void
			data_not_empty: not a_data.is_empty
		do
			last_error := Void
			Result := serial_port.write_bytes (a_data)
			if not Result then
				if attached serial_port.last_error as e then
					last_error := e.twin
				end
			end
		end

	read_string (a_max_length: INTEGER): STRING_8
			-- Read up to `a_max_length` characters from Bluetooth device.
		require
			is_open: is_open
			positive_length: a_max_length > 0
		do
			last_error := Void
			Result := serial_port.read_string (a_max_length)
			if attached serial_port.last_error as e then
				last_error := e.twin
			end
		ensure
			result_exists: Result /= Void
		end

	read_bytes (a_max_length: INTEGER): ARRAY [NATURAL_8]
			-- Read up to `a_max_length` bytes from Bluetooth device.
		require
			is_open: is_open
			positive_length: a_max_length > 0
		do
			last_error := Void
			Result := serial_port.read_bytes (a_max_length)
			if attached serial_port.last_error as e then
				last_error := e.twin
			end
		ensure
			result_exists: Result /= Void
		end

	read_line: STRING_8
			-- Read until newline or timeout.
		require
			is_open: is_open
		do
			last_error := Void
			Result := serial_port.read_line
			if attached serial_port.last_error as e then
				last_error := e.twin
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Configuration

	set_config (a_config: SERIAL_PORT_CONFIG)
			-- Change configuration (applies on next open).
		require
			config_exists: a_config /= Void
			not_open: not is_open
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

	set_baud_rate (a_rate: INTEGER)
			-- Set baud rate (applies on next open).
		require
			not_open: not is_open
			valid_rate: a_rate > 0
		do
			config := config.set_baud_rate (a_rate)
		ensure
			rate_set: config.baud_rate = a_rate
		end

feature {NONE} -- Implementation

	serial_port: SERIAL_PORT
			-- Underlying serial port from simple_serial.

invariant
	port_name_exists: port_name /= Void
	port_name_not_empty: not port_name.is_empty
	config_exists: config /= Void
	serial_port_exists: serial_port /= Void

end
