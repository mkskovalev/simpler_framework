class TestsController < Simpler::Controller

  def index
    # render html: 'tests/index'
    render plain: "Plain text response"
    @tests = Test.all
  end

  def create
  end

end
