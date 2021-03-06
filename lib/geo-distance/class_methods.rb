class GeoDistance 
  # this is global because if computing lots of track point distances, it didn't make 
  # sense to new a Hash each time over potentially 100's of thousands of points

  module ClassMethods
    # radius of the great circle in miles
    # radius in kilometers...some algorithms use 6367
        
    def distance(*args) 
      klass = case default_algorithm
      when :flat
        GeoDistance::Flat
      when :haversine
        GeoDistance::Haversine
      when :spherical
        GeoDistance::Spherical        
      when :vincenty
        GeoDistance::Vincenty
      when :nvector
        GeoDistance::NVector
      else
        raise ArgumentError, "Not a valid algorithm. Must be one of: #{algorithms}"
      end
      klass.distance *args
    end

    def default_units= name
      raise ArgumentError, "Not a valid units. Must be one of: #{all_units}" if !all_units.include?(name.to_sym)
      @default_units = GeoUnits.key(name)
    end

    def default_units
      @default_units || :kms
    end

    def default_algorithm= name
      raise ArgumentError, "Not a valid algorithm. Must be one of: #{algorithms}" if !algorithms.include?(name.to_sym)
      @default_algorithm = name 
    end
    
    def default_algorithm 
      @default_algorithm || :haversine
    end

    def earth_radius units
      GeoUnits.earth_radius units
    end

    def radians_per_degree
      0.017453293  #  PI/180
    end    
        
    def radians_ratio unit
      GeoDistance.radians_per_degree * earth_radius[unit]          
    end

    def all_units
      GeoUnits.all_units
    end

    def units 
      GeoUnits.units
    end
    
    def algorithms
      [:flat, :haversine, :spherical, :vincenty, :nvector]
    end
  end
  
  extend ClassMethods       
end