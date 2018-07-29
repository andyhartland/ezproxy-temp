require 'test_helper'

class EzproxyTest < Minitest::Test
  def test_database
    database = EZproxy::Database.new
    refute database.empty?

    stanza = database['123Library']
    assert_kind_of EZproxy::Stanza, stanza
  end
end
