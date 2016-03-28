# frozen_string_literal: true

require 'test_helper'

class GraphTest < ActiveSupport::TestCase
  def test_graph
    FileUtils.rm_f Rails.root.join('Bug.png')

    Dir.chdir Rails.root do
      `rails g stateful_enum:graph bug`
    end

    assert File.exist?(Rails.root.join('Bug.png'))
  end
end
