# frozen_string_literal: true

require 'shellwords'
require_relative 'rfm_hint_grouping'

module Kramdown
  module Parser
    # RFM is the newer GitHub-alert-style Markdown syntax used alongside the
    # legacy RPF block syntax. This module keeps that parsing isolated from the
    # older `--- block ---` parser definitions in KramdownRPF.
    module RFM
      include RFMHintGrouping

      MARKER_TO_ELEMENT = {
        'ACCORDION' => :collapse,
        'CHALLENGE' => :challenge,
        'DEBUG' => :debug,
        'HINT' => :hint,
        'NOPRINT' => :no_print,
        'PRINTONLY' => :print_only,
        'SAVE' => :save,
        'TASK' => :task,
        'TIP' => :tip,
        'INFO' => :info
      }.freeze
      MARKERS_PATTERN = MARKER_TO_ELEMENT.keys.join('|')
      TITLE_MARKERS = %w[ACCORDION DEBUG TIP].freeze
      MARKER_LINE_REGEXP = /\A\[!(#{MARKERS_PATTERN})\](?:[ \t]+([^\n]*))?[ \t]*(?:\n|\z)/
      SPLIT_MARKER_LINE_REGEXP = /^\[!(#{MARKERS_PATTERN})\](?:[ \t]+[^\n]*)?[ \t]*$/
      FENCE_LINE_REGEXP = /\A {0,3}([`~]{3,})/
      FENCED_CODEBLOCK_MATCH = /^ {0,3}(([~`]){3,})[ \t]*(.*?)\n(.*?)^ {0,3}\1\2*[ \t]*\n/m
      CODE_META_KEYS = %w[
        filename
        line_numbers
        line_number_start
        line_numbers_start
        line_highlights
      ].freeze

      def parse
        super
        group_rfm_hints(@root)
      end

      # Keep ordinary GFM fences untouched; only fences with RPF metadata become
      # the richer :code element used by the existing converter.
      # rubocop:disable Naming/PredicateMethod
      def parse_codeblock_fenced
        return false unless @src.check(FENCED_CODEBLOCK_MATCH)

        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        language, meta = parse_codeblock_info_string(@src[3].to_s.strip)

        if meta.empty?
          add_standard_codeblock(@src[4], language, start_line_number)
        else
          add_rfm_codeblock(@src[4], language, meta, start_line_number)
        end

        true
      end
      # rubocop:enable Naming/PredicateMethod

      def parse_blockquote
        start_line_number = @src.current_line_number
        result = @src.scan(self.class::PARAGRAPH_MATCH)
        result << @src.scan(self.class::PARAGRAPH_MATCH) until @src.match?(self.class::LAZY_END)
        result.gsub!(self.class::BLOCKQUOTE_START, '')

        if (segments = rfm_blockquote_segments(result))
          append_rfm_blockquotes(segments, start_line_number)
        else
          append_standard_blockquote(result, start_line_number)
        end
      end

      private

      def append_rfm_blockquotes(segments, line_number)
        segments.each do |segment|
          marker, title, content = rfm_blockquote_parts(segment)
          value = { content: content }
          value[:title] = title if title && TITLE_MARKERS.include?(marker)

          @tree.children << ::Kramdown::Element.new(MARKER_TO_ELEMENT.fetch(marker), value, nil,
                                                    location: line_number, rfm: true)
        end
      end

      def append_standard_blockquote(markdown, line_number)
        el = new_block_el(:blockquote, nil, nil, location: line_number)
        @tree.children << el
        parse_blocks(el, markdown)
        el
      end

      def add_standard_codeblock(code, language, line_number)
        el = new_block_el(:codeblock, code, nil, location: line_number, fenced: true)
        language_name = codeblock_language_name(language)

        unless language_name.empty?
          el.options[:lang] = language
          el.attr['class'] = "language-#{language_name}"
        end

        @tree.children << el
      end

      def add_rfm_codeblock(code, language, meta, line_number)
        meta['language'] = codeblock_language_name(language)
        @tree.children << ::Kramdown::Element.new(:code, { meta: meta, code: "\n#{code}" }, nil,
                                                  location: line_number, rfm: true)
      end

      def rfm_blockquote_segments(markdown)
        return nil unless MARKER_LINE_REGEXP.match?(markdown)

        segments = []
        current_segment = []
        fence = nil

        markdown.lines.each_with_index do |line, index|
          if fence.nil? && index.positive? && SPLIT_MARKER_LINE_REGEXP.match?(line)
            segments << current_segment.join
            current_segment = []
          end

          current_segment << line
          fence = update_rfm_fence(line, fence)
        end

        segments << current_segment.join unless current_segment.empty?
        segments
      end

      def rfm_blockquote_parts(segment)
        marker_match = MARKER_LINE_REGEXP.match(segment)
        marker = marker_match[1]
        title = marker_match[2]&.rstrip
        content = segment[marker_match.end(0)..] || ''

        [marker, title, content]
      end

      def update_rfm_fence(line, fence)
        match = FENCE_LINE_REGEXP.match(line)
        return fence unless match

        marker = match[1]
        if fence
          same_marker = marker.start_with?(fence[:char]) && marker.length >= fence[:length]
          same_marker ? nil : fence
        else
          { char: marker[0], length: marker.length }
        end
      end

      def parse_codeblock_info_string(info_string)
        tokens = shellwords_split(info_string)
        language = tokens.shift.to_s
        meta = {}

        tokens.each do |token|
          key, value = token.split('=', 2)
          next unless value && CODE_META_KEYS.include?(key)

          meta[key] = value
        end

        [language, meta]
      end

      def shellwords_split(value)
        Shellwords.split(value)
      rescue ArgumentError
        value.split(/\s+/)
      end

      def codeblock_language_name(language)
        language.to_s.split('?', 2).first.to_s
      end
    end
  end
end
