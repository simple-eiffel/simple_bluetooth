note
	description: "Test application for simple_bluetooth"
	author: "Larry Rix"
	date: "$Date$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running simple_bluetooth tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature -- Test Runners

	run_lib_tests
			-- Run core library tests.
		local
			tests: LIB_TESTS
		do
			create tests
			run_test (agent tests.test_device_creation, "test_device_creation")
			run_test (agent tests.test_device_unknown, "test_device_unknown")
			run_test (agent tests.test_device_display_name, "test_device_display_name")
			run_test (agent tests.test_scanner_creation, "test_scanner_creation")
			run_test (agent tests.test_scanner_scan, "test_scanner_scan")
			run_test (agent tests.test_port_creation, "test_port_creation")
			run_test (agent tests.test_port_from_device, "test_port_from_device")
			run_test (agent tests.test_port_config, "test_port_config")
			run_test (agent tests.test_facade_creation, "test_facade_creation")
			run_test (agent tests.test_facade_configs, "test_facade_configs")
			run_test (agent tests.test_facade_scan, "test_facade_scan")
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and track results.
		do
			print ("  " + a_name + "...")
			a_test.call (Void)
			passed := passed + 1
			print ("OK%N")
		rescue
			failed := failed + 1
			print ("FAILED%N")
		end

end
