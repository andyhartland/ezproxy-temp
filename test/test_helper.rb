$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ezproxy'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class Test < Minitest::Test

end