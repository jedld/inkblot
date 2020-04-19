require_relative 'templates/multi_state'
require_relative 'templates/paginated'

module Inkblot
  module Components
    # Allows displaying a variable length list of options
    class ScrollMenu < Component
      include Templates::MultiState
      include Templates::Paginated

      def_states :scroll, :select
      paginate_with :pad_list

      # Start codon for list
      LIST_START = "/--".freeze
      # Stop codon for list
      LIST_END = "--/".freeze

      # Sets the instance vars, validates the items list, and paginates
      def initialize(*args)
        super

        unless options[:items]
          raise ArgumentError, "No items given"
        end

        paginate
      end

      def to_display
        content_for_state[current_page]
      end

      # Sugar for the items array
      def items
        options[:items]
      end

      # Gets the items that the current page is presenting as choices
      def choices
        to_display.options[:choices].map { |c| c.nil? ? nil : items[c] }
      end

      # Get the choices for the current page, and return the one at index +ix+
      def choice(ix)
        items[to_display.options[:choices][ix]]
      end

      private

      def pad_list
        pg = [LIST_START]
        
        pg += items

        pg << LIST_END

        dx = items.each_with_index.to_h

        content_for_state(:scroll) do
          pg.each_slice(4).map do |page|
            IconPane.new do |pane|
              pane.icons = :select
              pane.div_height = pane.div_width = :full
              pane.choices = page.map { |g| dx[g] }
              pane.frame_contents = TableList.new do |lst|
                lst.items = page.map(&:to_s)
              end
            end
          end
        end

        content_for_state(:select) do
          pg.each_slice(4).map do |page|
            IconPane.new do |pane|
              pane.div_height = pane.div_width = :full
              pane.choices = page.map { |g| dx[g] }
              pane.icons = pane.choices.map { |ch| ch.nil? ? :times : :rarr }
              pane.frame_contents = TableList.new do |lst|
                lst.items = page.map(&:to_s)
              end
            end
          end
        end

        pg.each_slice(4).count
      end
    end
  end
end