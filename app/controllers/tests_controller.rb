class TestsController < Simpler::Controller

  def index
    # render html: 'tests/index'
    # render plain: "Plain text response", status: 201, headers: { 'Content-Type' => 'text/plain' }
    @tests = Test.all
  end

  def create
  end

  def show
    @id = params[:id]
  end
end
