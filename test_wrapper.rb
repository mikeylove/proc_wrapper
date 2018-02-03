require './proc_wrapper.rb'

examples = [
  [:run_with_block, <<-CODE
    ProcWrapper.new(10).run { _ + 10 }
    CODE
  ],

  [:run_pipeline, <<-CODE
    pipeline = [
      -> { _ + 10 },
      -> { _ * 2  }
    ]

    ProcWrapper.new(10).runs(*pipeline)
    CODE
  ],

  [:compose_pipeline, <<-CODE
    pipeline = [
      -> { _ + 10 },
      -> { _ * 2  }
    ]

    ProcWrapper.compose(*pipeline)[10]
    CODE
  ],

  [:indexed_underscore, <<-CODE
    # Contrived example of arg flipping.
    ProcWrapper.new(10, 20).run { [_(1), _(0)] }
  CODE
  ],

  [:enumerable_wmap, <<-CODE
    [1, 2, 3].wmap { _ * 2 }
  CODE
  ],
]

separator_length = examples.map do |e|
  ProcWrapper.new(e).run {
    _[1].split("\n").map do |s| s.length end.max
  }
end.max

res = examples.map do |name, example|
  [ name,
    example,
    "result: #{eval example}"
  ].join("\n#{"-" * separator_length}\n")
end.join("\n" * 3)

print "#{res}\n"
