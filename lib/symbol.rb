class Symbol
  def chop
    to_s.chop.to_sym
  end

  def last
    slice(-1, 1)
  end
end
