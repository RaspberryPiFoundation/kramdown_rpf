# frozen_string_literal: true

require 'kramdown'
require 'kramdown/parser/gfm'
require 'shellwords'
require_relative 'rpf'

module Kramdown
  module Converter
    class Html
      # Convert :challenge -> HTML
      # @api private
      def convert_challenge(element, _indent)
        RPF::Plugin::Kramdown.convert_challenge_to_html(element.value)
      end

      # Convert :code_filename -> HTML
      # @api private
      def convert_code(element, _indent)
        RPF::Plugin::Kramdown.convert_code_to_html(element.value)
      end

      # Convert :collapse -> HTML
      # @api private
      def convert_collapse(element, _indent)
        RPF::Plugin::Kramdown.convert_collapse_to_html(element.value)
      end

      # Convert :debug -> HTML
      # @api private
      def convert_debug(element, _indent)
        RPF::Plugin::Kramdown.convert_debug_to_html(element.value)
      end

      # Convert :hint -> HTML
      # @api private
      def convert_hint(element, _indent)
        RPF::Plugin::Kramdown.convert_hint_to_html(element.value)
      end

      # Convert :hints -> HTML
      # @api private
      def convert_hints(element, _indent)
        RPF::Plugin::Kramdown.convert_hints_to_html(element.value)
      end

      # Convert :knowledge_quiz_question -> HTML
      # @api private
      def convert_knowledge_quiz_question(element, indent)
        RPF::Plugin::Kramdown.convert_knowledge_quiz_question_to_html(element.value, indent)
      end

      # Convert :new_page -> HTML
      # @api private
      def convert_new_page(*)
        RPF::Plugin::Kramdown.convert_new_page_to_html
      end

      # Convert :no_print -> HTML
      # @api private
      def convert_no_print(element, _indent)
        RPF::Plugin::Kramdown.convert_no_print_to_html(element.value)
      end

      # Convert :print_only -> HTML
      # @api private
      def convert_print_only(element, _indent)
        RPF::Plugin::Kramdown.convert_print_only_to_html(element.value)
      end

      # Convert :quiz -> HTML
      # @api private
      def convert_quiz(element, _indent)
        RPF::Plugin::Kramdown.convert_quiz_to_html(element.value)
      end

      # Convert :save -> HTML
      # @api private
      def convert_save(*)
        RPF::Plugin::Kramdown.convert_save_to_html
      end

      # Convert :task -> HTML
      # @api private
      def convert_task(element, _indent)
        RPF::Plugin::Kramdown.convert_task_to_html(element.value)
      end

      # Convert :tip -> HTML
      # @api private
      def convert_tip(element, _indent)
        RPF::Plugin::Kramdown.convert_tip_to_html(element.value)
      end
    end

    module RaiseNotImplementedForUndefinedConvertMethods
      def method_missing(method_name, *args, &)
        raise NotImplementedError if method_name.to_s.start_with?('convert_')

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('convert_') || super
      end
    end

    class Kramdown
      include RaiseNotImplementedForUndefinedConvertMethods
    end

    class Latex
      include RaiseNotImplementedForUndefinedConvertMethods
    end
  end

  module Parser
    class KramdownRPF < ::Kramdown::Parser::GFM
      KEYWORDS = %w[
        challenge
        code
        collapse
        hints
        knowledge-quiz-question
        new-page
        no-print
        print-only
        quiz
        save
        task
      ].freeze

      CHALLENGE_PATTERN  = %r{^#{OPT_SPACE}---[ \t]*challenge[ \t]*---(.*?)---[ \t]*/challenge[ \t]*---}m
      CODE_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*code[ \t]*---(.*?)---[ \t]*/code[ \t]*---}m
      COLLAPSE_PATTERN   = %r{^#{OPT_SPACE}---[ \t]*collapse[ \t]*---(.*?)---[ \t]*/collapse[ \t]*---}m
      HINT_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*hint[ \t]*---(.*?)---[ \t]*/hint[ \t]*---}m
      HINTS_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*hints[ \t]*---(.*?)---[ \t]*/hints[ \t]*---}m
      NEW_PAGE_PATTERN   = /^#{OPT_SPACE}---[ \t]*new-page[ \t]*---/m
      NO_PRINT_PATTERN   = %r{^#{OPT_SPACE}---[ \t]*no-print[ \t]*---(.*?)---[ \t]*/no-print[ \t]*---}m
      PRINT_ONLY_PATTERN = %r{^#{OPT_SPACE}---[ \t]*print-only[ \t]*---(.*?)---[ \t]*/print-only[ \t]*---}m
      KNOWLEDGE_QUIZ_QUESTION_PATTERN = %r{^#{OPT_SPACE}---[ \t]*question[ \t]*---(.*?)---[ \t]*/question[ \t]*---}m
      QUIZ_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*quiz[ \t]*---(.*?)---[ \t]*/quiz[ \t]*---}m
      SAVE_PATTERN       = /^#{OPT_SPACE}---[ \t]*save[ \t]*---/m
      TASK_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*task[ \t]*---(.*?)---[ \t]*/task[ \t]*---}m
      RFM_MARKER_TO_ELEMENT = {
        'ACCORDION' => :collapse,
        'CHALLENGE' => :challenge,
        'DEBUG' => :debug,
        'HINT' => :hint,
        'NOPRINT' => :no_print,
        'PRINTONLY' => :print_only,
        'SAVE' => :save,
        'TASK' => :task,
        'TIP' => :tip
      }.freeze
      RFM_MARKERS_PATTERN = RFM_MARKER_TO_ELEMENT.keys.join('|')
      RFM_TITLE_MARKERS = %w[ACCORDION DEBUG TIP].freeze
      RFM_MARKER_LINE_REGEXP = /\A\[!(#{RFM_MARKERS_PATTERN})\](?:[ \t]+([^\n]*))?[ \t]*(?:\n|\z)/
      RFM_SPLIT_MARKER_LINE_REGEXP = /^\[!(#{RFM_MARKERS_PATTERN})\](?:[ \t]+[^\n]*)?[ \t]*$/
      RFM_FENCE_LINE_REGEXP = /\A {0,3}([`~]{3,})/
      RPF_FENCED_CODEBLOCK_MATCH = /^ {0,3}(([~`]){3,})[ \t]*(.*?)\n(.*?)^ {0,3}\1\2*[ \t]*\n/m
      RPF_CODE_META_KEYS = %w[
        filename
        line_numbers
        line_number_start
        line_numbers_start
        line_highlights
      ].freeze

      def initialize(source, options)
        super
        @block_parsers.unshift(:challenge)
        @block_parsers.unshift(:code)
        @block_parsers.unshift(:collapse)
        @block_parsers.unshift(:hint)
        @block_parsers.unshift(:hints)
        @block_parsers.unshift(:knowledge_quiz_question)
        @block_parsers.unshift(:new_page)
        @block_parsers.unshift(:no_print)
        @block_parsers.unshift(:print_only)
        @block_parsers.unshift(:quiz)
        @block_parsers.unshift(:save)
        @block_parsers.unshift(:task)
      end

      def parse
        super
        group_rfm_hints(@root)
      end

      # Convert RFM fenced code blocks with metadata -> :code, otherwise keep GFM codeblocks.
      # @api private
      # rubocop:disable Naming/PredicateMethod
      def parse_codeblock_fenced
        return false unless @src.check(RPF_FENCED_CODEBLOCK_MATCH)

        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        info_string = @src[3].to_s.strip
        language, meta = parse_codeblock_info_string(info_string)

        if meta.empty?
          add_standard_codeblock(@src[4], language, start_line_number)
        else
          meta['language'] = codeblock_language_name(language)
          @tree.children << Element.new(:code, { meta: meta, code: "\n#{@src[4]}" }, nil,
                                        location: start_line_number, rfm: true)
        end

        true
      end
      # rubocop:enable Naming/PredicateMethod

      # Convert Markdown -> RFM blockquote elements, falling back to normal blockquotes.
      # @api private
      def parse_blockquote
        start_line_number = @src.current_line_number
        result = @src.scan(PARAGRAPH_MATCH)
        result << @src.scan(PARAGRAPH_MATCH) until @src.match?(self.class::LAZY_END)
        result.gsub!(BLOCKQUOTE_START, '')

        add_rfm_blockquote!(result, start_line_number) || begin
          el = new_block_el(:blockquote, nil, nil, location: start_line_number)
          @tree.children << el
          parse_blocks(el, result)
          true
        end
      end

      # Convert Markdown -> :challenge
      # @api private
      def parse_challenge
        @src.pos += @src.matched_size
        @tree.children << Element.new(:challenge, @src[1])
      end

      define_parser(:challenge, CHALLENGE_PATTERN)

      # Convert Markdown -> :code
      # @api private
      def parse_code
        @src.pos += @src.matched_size
        @tree.children << Element.new(:code, @src[1])
      end

      define_parser(:code, CODE_PATTERN)

      # Convert Markdown -> :collapse
      # @api private
      def parse_collapse
        @src.pos += @src.matched_size
        @tree.children << Element.new(:collapse, @src[1])
      end

      define_parser(:collapse, COLLAPSE_PATTERN)

      # Convert Markdown -> :hint
      # @api private
      def parse_hint
        @src.pos += @src.matched_size
        @tree.children << Element.new(:hint, @src[1])
      end

      define_parser(:hint, HINT_PATTERN)

      # Convert Markdown -> :hints
      # @api private
      def parse_hints
        @src.pos += @src.matched_size
        @tree.children << Element.new(:hints, @src[1])
      end

      define_parser(:hints, HINTS_PATTERN)

      # Convert Markdown -> :knowledge_quiz_question
      # @api private
      def parse_knowledge_quiz_question
        @src.pos += @src.matched_size
        @tree.children << Element.new(:knowledge_quiz_question, @src[1])
      end

      define_parser(:knowledge_quiz_question, KNOWLEDGE_QUIZ_QUESTION_PATTERN)

      # Convert Markdown -> :new_page
      # @api private
      def parse_new_page
        @src.pos += @src.matched_size
        @tree.children << Element.new(:new_page, @src[1])
      end

      define_parser(:new_page, NEW_PAGE_PATTERN)

      # Convert Markdown -> :no_print
      # @api private
      def parse_no_print
        @src.pos += @src.matched_size
        @tree.children << Element.new(:no_print, @src[1])
      end

      define_parser(:no_print, NO_PRINT_PATTERN)

      # Convert Markdown -> :print_only
      # @api private
      def parse_print_only
        @src.pos += @src.matched_size
        @tree.children << Element.new(:print_only, @src[1])
      end

      define_parser(:print_only, PRINT_ONLY_PATTERN)

      # Convert Markdown -> :quiz
      # @api private
      def parse_quiz
        @src.pos += @src.matched_size
        @tree.children << Element.new(:quiz, @src[1])
      end

      define_parser(:quiz, QUIZ_PATTERN)

      # Convert Markdown -> :save
      # @api private
      def parse_save
        @src.pos += @src.matched_size
        @tree.children << Element.new(:save, @src[1])
      end

      define_parser(:save, SAVE_PATTERN)

      # Convert Markdown -> :task
      # @api private
      def parse_task
        @src.pos += @src.matched_size
        @tree.children << Element.new(:task, @src[1])
      end

      define_parser(:task, TASK_PATTERN)

      private

      # rubocop:disable Naming/PredicateMethod
      def add_rfm_blockquote!(markdown, line_number)
        segments = rfm_blockquote_segments(markdown)
        return false unless segments

        segments.each do |segment|
          marker_match = RFM_MARKER_LINE_REGEXP.match(segment)
          marker = marker_match[1]
          title = marker_match[2]&.rstrip
          content = segment[marker_match.end(0)..] || ''
          value = { content: content }
          value[:title] = title if title && RFM_TITLE_MARKERS.include?(marker)

          @tree.children << Element.new(RFM_MARKER_TO_ELEMENT.fetch(marker), value, nil,
                                        location: line_number, rfm: true)
        end

        true
      end
      # rubocop:enable Naming/PredicateMethod

      def rfm_blockquote_segments(markdown)
        return nil unless RFM_MARKER_LINE_REGEXP.match?(markdown)

        segments = []
        current_segment = []
        fence = nil

        markdown.lines.each_with_index do |line, index|
          if fence.nil? && index.positive? && RFM_SPLIT_MARKER_LINE_REGEXP.match?(line)
            segments << current_segment.join
            current_segment = []
          end

          current_segment << line
          fence = update_rfm_fence(line, fence)
        end

        segments << current_segment.join unless current_segment.empty?
        segments
      end

      def update_rfm_fence(line, fence)
        match = RFM_FENCE_LINE_REGEXP.match(line)
        return fence unless match

        marker = match[1]
        if fence
          same_marker = marker.start_with?(fence[:char]) && marker.length >= fence[:length]
          same_marker ? nil : fence
        else
          { char: marker[0], length: marker.length }
        end
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

      def parse_codeblock_info_string(info_string)
        tokens = shellwords_split(info_string)
        language = tokens.shift.to_s
        meta = {}

        tokens.each do |token|
          key, value = token.split('=', 2)
          next unless value && RPF_CODE_META_KEYS.include?(key)

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

      def group_rfm_hints(element)
        element.children.each { |child| group_rfm_hints(child) }
        grouped_children = []
        index = 0

        while index < element.children.length
          child = element.children[index]
          unless rfm_hint?(child)
            grouped_children << child
            index += 1
            next
          end

          hints, trailing_blanks, index = collect_adjacent_hints(element.children, index)
          grouped_children.concat(group_hints(hints))
          grouped_children.concat(trailing_blanks)
        end

        element.children = grouped_children
      end

      def collect_adjacent_hints(children, index)
        hints = [children[index]]
        index += 1

        loop do
          blanks = []
          while index < children.length && children[index].type == :blank
            blanks << children[index]
            index += 1
          end

          return [hints, blanks, index] unless index < children.length && rfm_hint?(children[index])

          hints << children[index]
          index += 1
        end
      end

      def rfm_hint?(element)
        element.type == :hint && element.options[:rfm]
      end

      def group_hints(hints)
        return hints if hints.length == 1

        hint_blocks = hints.map do |hint|
          "--- hint ---\n#{hint.value[:content]}\n--- /hint ---"
        end

        [Element.new(:hints, hint_blocks.join("\n"), nil,
                     location: hints.first.options[:location], rfm: true)]
      end
    end
  end

  class ParseError < RuntimeError; end

  class Document
    def to_html
      output, warnings = Kramdown::Converter::Html.convert(@root, @options)
      @warnings.concat(warnings)
      validate!(output)
    end

    private

    def validate!(output)
      keywords = ::Kramdown::Parser::KramdownRPF::KEYWORDS
      invalid = keywords.select { |keyword| output =~ Regexp.new("—[\s]*#{keyword}[\s]*—") }
      raise ParseError, "Markdown contained an unclosed tag: #{invalid}" unless invalid.empty?

      output
    end
  end
end
