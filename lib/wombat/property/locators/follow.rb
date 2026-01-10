#coding: utf-8

module Wombat
  module Property
    module Locators
      class Follow < Base
        def locate(context, page = nil)
          super do
            locate_nodes(context).flat_map do |node|
              begin
                mechanize_page = context.mechanize_page
                link = Mechanize::Page::Link.new(node, page, mechanize_page)
                target_page = page.click link
                context = target_page.parser
                context.mechanize_page = mechanize_page
                context.url = target_page.uri.to_s

                filter_properties(context, page)
              rescue Mechanize::ResponseCodeError
                # This is useful when a follow link is not working but you dont want the crawler to crash
                nil
              end
            end
          end
        end
      end
    end
  end
end
