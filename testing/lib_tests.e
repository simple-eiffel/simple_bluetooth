note
	description: "Core tests for simple_bluetooth library"
	author: "Larry Rix"
	date: "$Date$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Device Tests

	test_device_creation
			-- Test BLUETOOTH_DEVICE creation.
		local
			device: BLUETOOTH_DEVICE
		do
			create device.make ("HC-05", "00:14:03:05:59:22", "COM6")
			assert_strings_equal ("name", "HC-05", device.name)
			assert_strings_equal ("address", "00:14:03:05:59:22", device.address)
			assert_strings_equal ("port", "COM6", device.com_port)
			assert_false ("not_unknown", device.is_unknown)
			assert ("has_valid_address", device.has_valid_address)
		end

	test_device_unknown
			-- Test unknown device creation.
		local
			device: BLUETOOTH_DEVICE
		do
			create device.make_unknown ("COM7")
			assert ("is_unknown", device.is_unknown)
			assert_strings_equal ("port", "COM7", device.com_port)
			assert_false ("no_valid_address", device.has_valid_address)
		end

	test_device_display_name
			-- Test display name formatting.
		local
			device: BLUETOOTH_DEVICE
		do
			create device.make ("OBD-II Adapter", "AA:BB:CC:DD:EE:FF", "COM8")
			assert_string_contains ("display_has_name", device.display_name, "OBD-II Adapter")
			assert_string_contains ("display_has_port", device.display_name, "COM8")
		end

feature -- Scanner Tests

	test_scanner_creation
			-- Test scanner initialization.
		local
			scanner: BLUETOOTH_SCANNER
		do
			create scanner.make
			assert_integers_equal ("initial_count", 0, scanner.device_count)
			assert_false ("not_scanning", scanner.is_scanning)
		end

	test_scanner_scan
			-- Test scanning for devices.
		local
			scanner: BLUETOOTH_SCANNER
		do
			create scanner.make
			scanner.scan
			assert_false ("not_scanning_after", scanner.is_scanning)
			-- Note: May or may not find devices depending on system
			assert_non_negative ("count", scanner.device_count)
		end

	test_scanner_filters_fixed_ports
			-- From fixed Windows and Linux ports, the scanner keeps exactly the
			-- Bluetooth ones, once each, as unknown devices on their own ports.
		local
			l_scanner: BLUETOOTH_SCANNER
			l_ports: SERIAL_PORT_ENUMERATOR
		do
			create l_ports.make_empty
			l_ports.put_port ("COM5", "Standard Serial over Bluetooth link (COM5)", "BTHENUM\{00001101-0000-1000-8000-00805F9B34FB}_LOCALMFG&0002")
			l_ports.put_port ("COM3", "USB Serial Device (COM3)", "USB\VID_2341&PID_0043&REV_0001")
			l_ports.put_port ("COM1", "Communications Port (COM1)", "ACPI\PNP0501")
			l_ports.put_port ("COM6", "Serial Port (COM6)", "BTHENUM\{00001101-0000-1000-8000-00805F9B34FB}_LOCALMFG&0000")
			l_ports.put_port ("/dev/rfcomm0", "Bluetooth Serial Port", "")
			l_ports.put_port ("/dev/ttyUSB0", "USB Serial Port", "")

			create l_scanner.make
			l_scanner.add_devices_from (l_ports)
			assert_integers_equal ("three bluetooth ports", 3, l_scanner.device_count)
			assert_true ("com5 by friendly name", l_scanner.has_port ("COM5"))
			assert_true ("com6 by hardware id", l_scanner.has_port ("COM6"))
			assert_true ("rfcomm0", l_scanner.has_port ("/dev/rfcomm0"))
			assert_false ("usb skipped", l_scanner.has_port ("COM3"))
			assert_false ("motherboard port skipped", l_scanner.has_port ("COM1"))
			assert_false ("linux usb skipped", l_scanner.has_port ("/dev/ttyUSB0"))
			assert_true ("unknown device", attached l_scanner.device_for_port ("COM5") as l_device and then l_device.is_unknown)

			l_scanner.add_devices_from (l_ports)
			assert_integers_equal ("no duplicates", 3, l_scanner.device_count)
		end

	test_scan_matches_serial_filter
			-- A real scan finds a device for exactly the ports simple_serial
			-- calls Bluetooth on this machine, however many there are.
		local
			l_scanner: BLUETOOTH_SCANNER
			l_ports: SERIAL_PORT_ENUMERATOR
		do
			create l_scanner.make
			l_scanner.scan
			create l_ports.make
			print ("%N    bluetooth devices found: " + l_scanner.device_count.out + "%N    ")
			assert_integers_equal ("one device per bluetooth port", l_ports.bluetooth_ports.count, l_scanner.device_count)
			across l_ports.bluetooth_ports as ic_port loop
				assert_true ("device on bluetooth port", l_scanner.has_port (ic_port))
			end
		end

feature -- Port Tests

	test_port_creation
			-- Test BLUETOOTH_SERIAL_PORT creation.
		local
			port: BLUETOOTH_SERIAL_PORT
		do
			create port.make ("COM99")
			assert_strings_equal ("port_name", "COM99", port.port_name)
			assert_false ("not_open", port.is_open)
			assert_void ("no_device", port.device)
		end

	test_port_from_device
			-- Test port creation from device.
		local
			device: BLUETOOTH_DEVICE
			port: BLUETOOTH_SERIAL_PORT
		do
			create device.make ("Test Device", "11:22:33:44:55:66", "COM10")
			create port.make_for_device (device)
			assert_strings_equal ("port_name", "COM10", port.port_name)
			assert_attached ("has_device", port.device)
		end

	test_port_config
			-- Test port configuration.
		local
			port: BLUETOOTH_SERIAL_PORT
			config: SERIAL_PORT_CONFIG
		do
			create config.make_default
			config := config.set_baud_rate (115200)

			create port.make_with_config ("COM11", config)
			assert_integers_equal ("baud_rate", 115200, port.config.baud_rate)
		end

feature -- Facade Tests

	test_facade_creation
			-- Test SIMPLE_BLUETOOTH facade.
		local
			bt: SIMPLE_BLUETOOTH
		do
			create bt
			assert_integers_equal ("no_devices", 0, bt.device_count)
			assert_false ("not_connected", bt.is_connected)
		end

	test_facade_configs
			-- Test factory configuration methods.
		local
			bt: SIMPLE_BLUETOOTH
		do
			create bt
			assert_integers_equal ("config_9600", 9600, bt.config_9600.baud_rate)
			assert_integers_equal ("config_115200", 115200, bt.config_115200.baud_rate)
			assert_integers_equal ("config_38400", 38400, bt.config_38400.baud_rate)
		end

	test_facade_scan
			-- Test device scanning.
		local
			bt: SIMPLE_BLUETOOTH
		do
			create bt
			bt.scan
			-- May or may not find devices
			assert_non_negative ("device_count", bt.device_count)
		end

end
