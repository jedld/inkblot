require 'inkblot/version'
require 'inkblot/gpio'
require 'inkblot/buttons'
require 'inkblot/display'
require 'inkblot/converters'
require 'inkblot/components'

# Ruby gem for interacting with waveshare e-Paper display
module Inkblot

  # The possible color depths for rendering images with.
  COLOR_DEPTH = [1, 4].freeze

  class << self
    # Returns the path to the vendor directory for this gem, to access non-ruby
    # assets like python code and html templates.
    # If +paths+ are appended, joins them to the base with '/'
    def vendor_path(*paths)
      @vendor_path ||= File.join(__dir__, '..', 'vendor')

      return @vendor_path if paths.empty?

      [String.new(@vendor_path)].concat(paths).join('/')
    end

    # Allows for overwriting of the screen size for different HATs
    attr_writer :screen_size

    # Aspect ratio of the screen
    def screen_size
      @screen_size ||= {
        width: 264,
        height: 176
      }
    end

    # Allows for overwriting of the button pinout for different HATs
    attr_writer :button_pinout

    # Which pins are assigned to which of the four buttons, from top down
    def button_pinout
      @button_pinout ||= [5, 6, 13, 19].freeze
    end

    # Whether we use 2-bit or 4-bit color
    def color_depth
      @color_depth ||= 1
    end

    # Sets the +new_depth+ if it's in range
    def color_depth=(new_depth)
      unless COLOR_DEPTH.include?(new_depth)
        raise ArgumentError, "Unsupported depth '#{new_depth}'" 
      end

      @color_depth = new_depth
    end

    private

    # Figures out where to look for gems using Gem.path
    def locate_gem_folder
      looks, _nopes = Gem.path.partition { |pth| Dir.exist?(pth) }

      has_them, _doesnt = looks.partition do |pth|
        Dir.entries(pth).include?('gems')
      end

      has_them.first
    end
  end
end
