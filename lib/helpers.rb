def process(cmd, input, parking_lot)
  klazz = Object.const_get("#{cmd}_args".classify)
  args = klazz.new(input[1..-1]).args

  result = args.nil? ? parking_lot.send(cmd) : parking_lot.send(cmd, *args)
  parking_lot.send("#{cmd}_say".to_sym, result)
end
