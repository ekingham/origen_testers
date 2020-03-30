Pattern.create(name: "test_overlay_no_start") do
  tester.overlay_style = :digsrc
  # increase coverage by changing tdi dig src settings
  tester.source_memory :digsrc do |mem| 
    mem.pin :tdi, size: 32
  end
  cc 'should get a repeat count added to this vector for digsrc start minimum distance'
  tester.cycle
  
  dut.pin(:tclk).drive(1)
  dut.pin(:tdi).drive(1)
  dut.pin(:tdo).assert(1)
  dut.pin(:tms).drive(1)
  
  cc 'should get a repeat 5 vector'
  tester.cycle repeat: 5

  tester.digsrc_skip_start :tdi_a if tester.ultraflex?
  tester.digsrc_skip_start :pa if tester.ultraflex?
  
  cc 'should get a send microcode and 1 cycle with D'
  tester.cycle overlay: {overlay_str: 'dummy_str', pins: dut.pin(:tdi_a)}
  cc 'should get a cycle with D and no send'
  tester.cycle overlay: {overlay_str: 'dummy_str', pins: dut.pin(:tdi_a), change_data: false}
  cc 'regular cycle with no D or send'
  tester.cycle
  
  cc 'cycle with 001 on pa'
  dut.pin(:pa).drive!(1)
  cc 'send microcode followed by DDD on pa'
  dut.pin(:pa).drive(0)
  tester.cycle overlay: {overlay_str: "dummy_str", pins: dut.pin(:pa)}
  cc 'cycle with 001 on pa'
  dut.pin(:pa).drive!(1)
  cc 'send microcode, DDD on pa with repeat 5 (will send 5 sets of data)'
  dut.pin(:pa).drive(0)
  tester.cycle repeat: 5, overlay: {overlay_str: "dummy_str", pins: dut.pin(:pa)}
  cc 'cycle with 001 on pa'
  dut.pin(:pa).drive!(1)
  
end
