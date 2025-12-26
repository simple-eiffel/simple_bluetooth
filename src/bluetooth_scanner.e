note
	description: "[
		BLUETOOTH_SCANNER - Discovers paired Bluetooth devices

		Scans for Bluetooth Serial Port Profile (SPP) devices that are
		paired and have virtual COM ports assigned by Windows.

		Phase 1 Implementation:
		- Uses simple_serial's port enumerator to find Bluetooth COM ports
		- Queries Windows registry for device name/address mapping
		- Returns list of BLUETOOTH_DEVICE objects

		Example:
			scanner: BLUETOOTH_SCANNER
			create scanner.make
			scanner.scan
			across scanner.devices as d loop
				print (d.display_name + "%%N")
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	BLUETOOTH_SCANNER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize scanner.
		do
			create devices.make (5)
			create serial_enumerator.make
		end

feature -- Access

	devices: ARRAYED_LIST [BLUETOOTH_DEVICE]
			-- Discovered Bluetooth devices.

	device_count: INTEGER
			-- Number of discovered devices.
		do
			Result := devices.count
		end

	device_at (a_index: INTEGER): BLUETOOTH_DEVICE
			-- Device at position `a_index`.
		require
			valid_index: a_index >= 1 and a_index <= device_count
		do
			Result := devices [a_index]
		end

feature -- Status

	has_devices: BOOLEAN
			-- Were any Bluetooth devices found?
		do
			Result := not devices.is_empty
		end

	is_scanning: BOOLEAN
			-- Is a scan currently in progress?

feature -- Operations

	scan
			-- Scan for paired Bluetooth devices.
		do
			is_scanning := True
			devices.wipe_out

			-- Use simple_serial's enumerator to find Bluetooth ports
			serial_enumerator.refresh
			across serial_enumerator.bluetooth_ports as port loop
				add_device_for_port (port)
			end

			is_scanning := False
		ensure
			not_scanning: not is_scanning
		end

	refresh
			-- Re-scan for devices.
		do
			scan
		end

feature -- Query

	device_for_port (a_port: READABLE_STRING_GENERAL): detachable BLUETOOTH_DEVICE
			-- Find device using the specified COM port.
		do
			across devices as d loop
				if d.is_same_port (a_port) then
					Result := d
				end
			end
		end

	has_port (a_port: READABLE_STRING_GENERAL): BOOLEAN
			-- Is there a Bluetooth device on the specified port?
		do
			Result := device_for_port (a_port) /= Void
		end

feature {NONE} -- Implementation

	serial_enumerator: SERIAL_PORT_ENUMERATOR
			-- Serial port enumerator from simple_serial.

	add_device_for_port (a_port: STRING_32)
			-- Add a device for the given Bluetooth COM port.
		local
			l_device: BLUETOOTH_DEVICE
			l_name: detachable STRING_32
			l_address: detachable STRING_32
		do
			-- Try to get device info from registry
			l_name := query_device_name (a_port)
			l_address := query_device_address (a_port)

			if attached l_name as n and attached l_address as a then
				create l_device.make (n, a, a_port)
			else
				create l_device.make_unknown (a_port)
			end

			devices.extend (l_device)
		end

	query_device_name (a_port: READABLE_STRING_GENERAL): detachable STRING_32
			-- Query Windows registry for device name associated with port.
			-- Phase 1: Returns Void - full registry lookup planned for Phase 2.
		do
			-- Phase 1: Device name lookup requires enumerating BTHENUM registry keys
			-- and matching port numbers to device entries. Planned for Phase 2.
			Result := Void
		end

	query_device_address (a_port: READABLE_STRING_GENERAL): detachable STRING_32
			-- Query Windows registry for MAC address associated with port.
			-- Phase 1: Returns Void - full registry lookup planned for Phase 2.
		do
			-- Phase 1: Address lookup requires parsing BTHENUM device instance IDs.
			-- Planned for Phase 2.
			Result := Void
		end

invariant
	devices_exists: devices /= Void
	enumerator_exists: serial_enumerator /= Void

end
