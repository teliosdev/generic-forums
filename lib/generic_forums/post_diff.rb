class GenericForums::PostDiff
  attr_accessor :first, :second
  def initialize(p1, p2, split="\n")
    @first  = p2.split(split)
    @second = p1.split(split)
  end

  def run
    Diff::LCS.diff(@first, @second)
  end

  def to_diff
    result = ""
    oldhunk = hunk = nil
    fld = 0

    run.each do |b|
      begin
        hunk = Diff::LCS::Hunk.new(@first, @second, b, 3, fld)
        fld = hunk.file_length_difference

        next unless oldhunk

        if hunk.overlaps?(oldhunk)
          hunk.unshift(oldhunk)
        else
          result << oldhunk.diff(:unified)
        end
      ensure
        oldhunk = hunk
      end
    end

    result << oldhunk.diff(:unified)
    result << "\n"
    result
  end

  def to_html
    output = []
    callbacks = Callbacks.new(output)
    Diff::LCS.traverse_sequences(@first, @second, callbacks)
    output.join
  end

  class Callbacks

    def initialize(output)
      @output = output
    end

    def htmlize(data, klass)
      "<div class='diff #{ERB::Util.h(klass)}'>#{ERB::Util.h(data || '')}</div>"
    end

    def match(event)
      @output << htmlize(event.old_element, :diff_same)
    end

    def discard_a(event)
      @output << htmlize(event.old_element, :diff_del)
    end

    def discard_b(event)
      @output << htmlize(event.new_element, :diff_ins)
    end
  end
end
