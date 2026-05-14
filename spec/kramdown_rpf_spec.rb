# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be_nil
  end

  Dir.glob('spec/fixtures/*spec.md').each do |spec_file|
    it_behaves_like 'conforms to spec', spec_file
  end
end
