class ProcWrapper
  def initialize(*objs)
    @objs = objs
  end

  def run(&block)
    instance_exec &block
  end

  def runs(*blocks)
    blocks.reduce(@objs) do |acc, o|
      ProcWrapper.new(*acc).run &o
    end
  end

  def self.compose(*blocks)
    ->(init) {
      ProcWrapper.new(init).runs(*blocks)
    }
  end

  def _(i = 0)
    @objs[i]
  end
end

::Enumerable.class_exec {
  def wmap(&block)
    map do |e|
      ProcWrapper.new(e).run(&block)
    end
  end
}
