class Card
  attr_accessor :state
  attr_reader :face_value

  def initialize(face_value, state = :face_down)
    @state = state
    @face_value = face_value
  end

  def hide
    @state = :face_down
  end

  def reveal
    @state = :face_up
  end

  def to_s
    if state == :face_down
      "[  ]"
    else
      "[#{face_value} ]"
    end
  end
end
