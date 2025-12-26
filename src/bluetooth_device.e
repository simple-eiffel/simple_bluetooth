note
	description: "[
		BLUETOOTH_DEVICE - Represents a paired Bluetooth device

		Stores device information discovered from Windows Bluetooth registry.
		Bluetooth SPP devices appear as virtual COM ports after pairing.

		Example:
			device: BLUETOOTH_DEVICE
			create device.make ("HC-05", "00:14:03:05:59:22", "COM6")
			print (device.display_name) -- "HC-05 (COM6)"
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	BLUETOOTH_DEVICE

create
	make,
	make_unknown

feature {NONE} -- Initialization

	make (a_name, a_address, a_port: READABLE_STRING_GENERAL)
			-- Create device with known information.
		require
			name_not_empty: not a_name.is_empty
			address_not_empty: not a_address.is_empty
			port_not_empty: not a_port.is_empty
		do
			create name.make_from_string_general (a_name)
			create address.make_from_string_general (a_address)
			create com_port.make_from_string_general (a_port)
		ensure
			name_set: name.same_string_general (a_name)
			address_set: address.same_string_general (a_address)
			port_set: com_port.same_string_general (a_port)
		end

	make_unknown (a_port: READABLE_STRING_GENERAL)
			-- Create device with only COM port known (Bluetooth device without name).
		require
			port_not_empty: not a_port.is_empty
		do
			create name.make_from_string ("Unknown Device")
			create address.make_from_string ("00:00:00:00:00:00")
			create com_port.make_from_string_general (a_port)
		ensure
			is_unknown: is_unknown
			port_set: com_port.same_string_general (a_port)
		end

feature -- Access

	name: STRING_32
			-- Friendly name of the device (e.g., "HC-05", "OBD-II Adapter").

	address: STRING_32
			-- Bluetooth MAC address (e.g., "00:14:03:05:59:22").

	com_port: STRING_32
			-- Virtual COM port assigned by Windows (e.g., "COM6").

	display_name: STRING_32
			-- Human-readable display name.
		do
			create Result.make (name.count + com_port.count + 5)
			Result.append (name)
			Result.append (" (")
			Result.append (com_port)
			Result.append (")")
		ensure
			contains_name: Result.has_substring (name)
			contains_port: Result.has_substring (com_port)
		end

feature -- Status

	is_unknown: BOOLEAN
			-- Is this an unidentified Bluetooth device?
		do
			Result := name.same_string ("Unknown Device")
		end

	has_valid_address: BOOLEAN
			-- Is the MAC address valid (not all zeros)?
		do
			Result := not address.same_string ("00:00:00:00:00:00")
		end

feature -- Comparison

	is_same_device (other: BLUETOOTH_DEVICE): BOOLEAN
			-- Is this the same physical device as `other`?
		require
			other_exists: other /= Void
		do
			Result := address.same_string (other.address)
		end

	is_same_port (a_port: READABLE_STRING_GENERAL): BOOLEAN
			-- Does this device use the specified COM port?
		do
			Result := com_port.same_string_general (a_port)
		end

invariant
	name_not_void: name /= Void
	address_not_void: address /= Void
	port_not_void: com_port /= Void
	port_not_empty: not com_port.is_empty

end
