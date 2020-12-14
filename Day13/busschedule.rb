require 'pry'

class BusSchedule
  def initialize(filename)
    @schedule = File.readlines(filename, chomp: true)
    @sch_timestamp = @schedule[0].to_i
    @routes = @schedule[1].split(',').map { |route| route == 'x' ? route : route.to_i }
    @running = @routes.reject { |route| route == 'x' }
    @indices = @running.map { |route| @routes.index(route) }
    # binding.pry
  end

  def incoming
    # timestamps each bus are expected to arrive
    incoming = @running.map { |route| (@sch_timestamp / route) * route + route }

    # index of the earliest arriving bus
    index = incoming.index(incoming.min)

    # Pt 1 soln = earliest arriving bus no * minutes until it arrives
    @running[index] * (incoming.min - @sch_timestamp)
  end

  def seq_arrival_time
    timestamp = 0
    interval = 1
    @running.each_with_index do |route, index|
      timestamp += interval until (timestamp + @indices[index]) % route == 0
      interval *= route
    end
    timestamp
  end
end
